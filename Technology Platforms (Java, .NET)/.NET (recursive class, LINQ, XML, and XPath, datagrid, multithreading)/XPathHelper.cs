using System.Collections.Generic;
using System.Xml.Linq;
using System.Xml.XPath;

namespace WpfApp
{
    public static class XPathHelper
    {
        private const string expr = "/ArrayOfPerson/Person[Details/Priority[not(. = preceding::Person / Details / Priority) and not(. = following::Person / Details / Priority)]]";
           // "or" +
            //"  Details/HealthScore[not(. = preceding::Person / Details / HealthScore) and not(. = following::Person / Details / HealthScore)]]";

        public static IEnumerable<XElement> CallXPath(string xmlFilePath)
        {
            var doc = XDocument.Load(xmlFilePath);
            return doc.XPathSelectElements(expr);
        }
    }
}
