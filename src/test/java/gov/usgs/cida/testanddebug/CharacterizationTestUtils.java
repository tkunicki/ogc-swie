package gov.usgs.cida.testanddebug;

import gov.usgs.cida.config.DynamicReadOnlyProperties;
import gov.usgs.cida.testanddebug.CharacterizationMap.saveMode;

import java.io.File;
import java.net.URL;
import java.util.Properties;

/**
 * We'll start with making everything into a string. Later, to do objects with
 * deserialization
 *
 * @author ilinkuo
 *
 */
public class CharacterizationTestUtils {
	private static final String BASE_DIRECTORY_PROPERTY = "BASE_DIRECTORY";
	public static final String CHARACTERIZATION_TEST_CONFIG_FILE = "CTConfig.properties";
	public static final String defaultFileSuffix = "ctproperties";
	public static final CharacterizationMap DEFAULT_CHARACTERIZATION;
	private static final Properties props;
	public static final File BASE_DIRECTORY; // obtained from configuration file

	static { // static initializer block
		props = loadConfigProperties();
		BASE_DIRECTORY = initializeBaseDirectory();
		DEFAULT_CHARACTERIZATION = initCharacterizationMap(); //new CharacterizationMap(saveMode.SAVE_ON_PUT_REMOVE_AND_CLEAR);
	}

	public static Properties loadConfigProperties() {
		ClassLoader myClassLoader = CharacterizationTestHelper.class.getClassLoader();
		URL configFile = myClassLoader.getResource(CHARACTERIZATION_TEST_CONFIG_FILE);
		Properties workingProps = new DynamicReadOnlyProperties();
		// Configuration parameters may be provided either via an explicit configuration file, environment variables, or command-line
		// Example of command line arguments is -DBASE_DIRECTORY="C://Documents and Settings/ikuoikuo/My Documents/workspace/projects/usgs/IdeaPlayground/test"
		if (configFile == null) {
			System.out.println(
					String.format("Unable to find configuration file %s for %s",
							CHARACTERIZATION_TEST_CONFIG_FILE,
							CharacterizationTestUtils.class.getSimpleName())
			);
		} else {
			try {
				workingProps = new DynamicReadOnlyProperties();
				workingProps.load(myClassLoader.getResourceAsStream(CHARACTERIZATION_TEST_CONFIG_FILE));
			} catch (Exception e) {
				throw new ExceptionInInitializerError(
						String.format("Configuration file %s for %s found but could not be loaded",
								CHARACTERIZATION_TEST_CONFIG_FILE,
								CharacterizationTestUtils.class.getSimpleName(), e)
				);
			}
		}
		return workingProps;
	}

	public static File initializeBaseDirectory() {
		Object baseDir = props.get(BASE_DIRECTORY_PROPERTY);

//		for (Object key: props.keySet()) {
//			System.out.println(key + ": " + props.getProperty(key.toString()));
//		}

		if (baseDir != null) {
			String baseDirectoryPath = baseDir.toString();
			File baseDirectory = new File(baseDirectoryPath);
			if (baseDirectory != null) {
				if (!baseDirectory.exists()) {
					String errorMessage = String.format(
							"Value of BASE_DIRECTORY in %s [%s] points to a nonexistent directory. "
							+ "%s is unable to load configurations",
							CHARACTERIZATION_TEST_CONFIG_FILE, baseDirectoryPath,
							CharacterizationTestUtils.class.getSimpleName());
					System.err.println(errorMessage);
					throw new ExceptionInInitializerError("Cannot initialize " + CharacterizationTestUtils.class.getSimpleName());
				}
				return baseDirectory;
			}
		}
		throw new ExceptionInInitializerError("Cannot initialize " + CharacterizationTestUtils.class.getSimpleName()
				+ " due to nonspecification of BASE_DIRECTORY. BASE_DIRECTORY may be specified via a configuration file or via command line");
	}

	public static CharacterizationMap initCharacterizationMap() {
		Object saveModeConfig = props.get("SAVE_MODE");
		saveMode mode = (saveModeConfig == null) ? CharacterizationMap.saveMode.SAVE_ON_MODIFICATION
				: CharacterizationMap.saveMode.valueOf(saveModeConfig.toString());
		String defaultCharacterizationFileName = CharacterizationTestUtils.class.getSimpleName() + "." + defaultFileSuffix;
		File defaultCharacterizationFile = new File(BASE_DIRECTORY, defaultCharacterizationFileName);
		CharacterizationMap defaultCharac = new CharacterizationMap(mode, defaultCharacterizationFile);
		return defaultCharac;
	}

	public static String convertClassToPath(Class<?> clazz) {
		String fullClassName = clazz.getCanonicalName();
		return fullClassName.replace('.', File.separatorChar);
	}

	public static String convertClassToPropertiesPath(Class<?> clazz) {
		return convertClassToPath(clazz) + "." + defaultFileSuffix;
	}

	/**
	 * @param characterizations
	 * @param oKey
	 * @param oObject
	 * @return true if characterization did not previously exist
	 */
	public static boolean characterize(CharacterizationMap characterizations, Object oKey, Object oObject) {
		assert (oKey != null) : "null keys are not allowed for characterizations";
		String key = oKey.toString();
		Comparer characterization = characterizations.get(key);
		if (characterization == null) {
			characterizations.put(key, new Comparer(oObject));
			return true;
		}
		return false;
	}

	public static boolean characterize(Object oKey, Object oObject) {
		return characterize(DEFAULT_CHARACTERIZATION, oKey, oObject);
	}

	public static Object characterization(CharacterizationMap characterizations, Object key){
		Comparer characterization = characterizations.get(key.toString());
		if (characterization == null){
			// store the incoming compared object
			return new Recorder(characterizations, key.toString());
		} else {
			return characterization;
		}
	}

	public static Object characterization(Object key){
		return characterization(DEFAULT_CHARACTERIZATION, key);
	}

}
