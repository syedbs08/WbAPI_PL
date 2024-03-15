namespace PSI.Modules.Backends.Helpers
{
    public class DevExtreamFilterList
    {
       public List<FilterCommand> Filters { get; set; }
    }
    public class FilterCommand
    {
        public string FieldName { get; set; }
        public string Value { get; set; }
    }
}
