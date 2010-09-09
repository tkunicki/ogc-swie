package gov.usgs.cida.testanddebug;


/**
 * A testing object which intentionally violates the equals() and hashcode()
 * contracts. CharacterizationRecorder is meant to have only one method which is
 * called, the equals() method. When the equals method is called, it compares
 * the characterization it has stored to the in argument and returns equal if
 * the values are equal as Strings (and the class and hashcodes match). If there
 * is no stored characterization, then it persists the in argument
 *
 * @author ilinkuo
 *
 */
public class Recorder {
	public static final int DEFAULT_HASHCODE = 0;
	private final CharacterizationMap _characterizations;
	private final String key;

	public Recorder(CharacterizationMap characterizations, String key) {
		assert (characterizations != null);
		assert (key != null);
		this.key = key;
		_characterizations = characterizations;
	}

	/**
	 * Overridden equals() works as a simple put(key, value). This intentionally
	 * violates the equals() contract, so must be extremely careful if you put a
	 * Recorder in a Collection
	 *
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) {
		// store the given object as a characterization and return true
		if (!_characterizations.containsKey(key)){
			// only store if a value does not already exist
			_characterizations.put(key, new Comparer(obj));
		}
		return true;
	}

	/**
	 * In this case, the Recorder impersonates the hashCode() method of the
	 * characterized object
	 *
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		Comparer characterization = _characterizations.get(key);
		return (characterization != null) ? characterization.objHashCode
				: DEFAULT_HASHCODE;
	}

	/**
	 * In this case, the Recorder impersonates the toString() method of the
	 * characterized object.
	 *
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		Comparer characterization = _characterizations.get(key);
		return (characterization != null) ? characterization.objValue : null;

	}

	// can we override getClass if necessary?
}
