package gov.usgs.cida.testanddebug;

import static gov.usgs.cida.testanddebug.CharacterizationMap.saveMode.SAVE_ON_MODIFICATION;
import static gov.usgs.cida.testanddebug.CharacterizationTestUtils.convertClassToPropertiesPath;
import gov.usgs.cida.testanddebug.CharacterizationMap.saveMode;

import java.io.File;

public abstract class CharacterizationTestHelper {

	protected final CharacterizationMap myCharacterizations;

	// ============
	// CONSTRUCTORS (meant to be called by subclasses, hence protected)
	// ============
	protected CharacterizationTestHelper() {
		this(SAVE_ON_MODIFICATION, null);
	}

	protected CharacterizationTestHelper(CharacterizationMap.saveMode mode) {
		this(mode, null);
	}

	protected CharacterizationTestHelper(Class<?> clazz) {
		this(SAVE_ON_MODIFICATION, clazz);
	}

	protected CharacterizationTestHelper(saveMode mode, Class<?> clazz) {
		mode = (mode == null) ? SAVE_ON_MODIFICATION : mode;
		clazz = (clazz == null) ? getClass() : clazz;
		// pull base directory from utils configuration file
		String relativeFilePath = convertClassToPropertiesPath(clazz);
		File sourceFile = new File(CharacterizationTestUtils.BASE_DIRECTORY, relativeFilePath);
		myCharacterizations = new CharacterizationMap(mode, sourceFile);
	}

	// ================
	// INSTANCE METHODS
	// ================
	public boolean characterize(Object oKey, Object oObject) {
		return CharacterizationTestUtils.characterize(myCharacterizations, oKey, oObject);
	}

	public Object characterization(Object key){
		return CharacterizationTestUtils.characterization(myCharacterizations, key);
	}


}
