using DevExtreme.AspNet.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Helpers
{
    public class JsonCustomConverter : JsonConverter<DevExtreme.AspNet.Data.DataSourceLoadOptionsBase>
    {
        public override DataSourceLoadOptionsBase Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            if (reader.TokenType != JsonTokenType.StartObject)
            {
                throw new JsonException();
            }
            var dbOptions = new DataSourceLoadOptionsBase();
            while (reader.Read())
            {
                if (reader.TokenType == JsonTokenType.EndObject)
                {
                    return dbOptions;
                }

                if (reader.TokenType == JsonTokenType.PropertyName)
                {
                    string propertyName = reader.GetString();
                    reader.Read();
                    switch (propertyName)
                    {
                        case "Take":
                            dbOptions.Take = reader.GetInt32();
                            break;

                        case "Skip":
                            dbOptions.Skip = reader.GetInt32();
                            break;

                        case "RequireTotalCount":
                            dbOptions.RequireTotalCount = reader.GetBoolean();
                            break;

                        case "Filter":
                            dbOptions.Filter = new List<object>();
                            do
                            {
                                reader.Read();
                                switch (reader.TokenType)
                                {
                                    case JsonTokenType.String:
                                        dbOptions.Filter.Add(reader.GetString());
                                        break;
                                    case JsonTokenType.Number:
                                        dbOptions.Filter.Add(reader.GetDouble());
                                        break;
                                }
                            } while (reader.TokenType != JsonTokenType.EndArray);

                            break;
                    }
                }

            }

            throw new JsonException();
        }

        public override void Write(Utf8JsonWriter writer, DataSourceLoadOptionsBase value, JsonSerializerOptions options)
        {
            throw new NotImplementedException();
        }
    }
}
