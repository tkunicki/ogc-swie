package gov.usgs.cida.ogc.specs;

/**
 * Based on OGC Web Service Common standard (document 06-121r9)
 * at http://www.opengeospatial.org/standards/common
 * @author ilinkuo
 *
 */
public class OGC_WSCConstants {
	// Lists from p. 28 of 06-121r9
	public final String[] GetCapabilities_params = {"ServiceType","ServiceTypeVersion",
			"Profile","Title","Abstract","Keywords","Fees","AccessConstraints","ProviderName",
			"ProviderSite","ServiceContact","Operation","Parameter","Constraint",
			"ExtendedCapabilities","name","DCP","Metadata","HTTP","Get","Post","URL",
			"DatasetSummary","OtherSource"};
	public final String[] GetCaps_mandatoryKvpParams = {"service", "request"};
	public final String[] GetCaps_optionalKvpParams = {"Sections","updateSequence","AcceptVersions",
			"AcceptFormats","AcceptLanguages"};
	public final String[] GetCaps_sectionNameParameters = {"ServiceIdentification", 
			"ServiceProvider","OperationsMetadata","Contents","Languages","All"};
	public final String[] GetCaps_updateSequence_values = {"None", "Any", "Equal", 
			"Lower", "Higher"};
	public final String[] GetCaps_ExceptionCodes = {"MissingParameterValue","InvalidParameterValue",
			"VersionNegotiationFailed","InvalidUpdateSequence","NoApplicableCode"};
	// From Table 14
	public final String[] GetCaps_OperationMetadataStructure = {"name", "DCP", "parameter", "constraint", "metadata"};
	public final String[] GetCaps_DCPDataStructure = {"HTTP"};
	public final String[] GetCaps_HTTPDataStructure = {"get","post"};
	public final String[] GetCaps_RequestMethodDataStructure = {"URL", "constraint"};
	
	
	public final String[] Exception_report_responses = {"ExceptionReport","Exception",
			"ExceptionText","exceptionCode","locator","version","lang"};
	public final String[] OtherOperations_exceptGetCaps = {"service","request",
			"version","GetResourceByID","ResourceID"};
	public final String[] OtherDataStructures = {"Domaintype","UnNamedDomaintype",
			"name","defaultValue","PossibleValues","AllowedValues","AnyValue","NoValues",
			"ValuesReference","Value","Range","MinimumValue","MaximumValue","Spacing",
			"rangeClosure","DataType","Meaning","ValuesUnit","UOM","ReferenceSystem",
			"Manifest","ReferenceGroup","ReferenceBase","Reference","OperationResponse",
			"InputData","ServiceReference"};




}
