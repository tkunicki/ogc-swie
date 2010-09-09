package gov.usgs.cida.testanddebug;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

public class CharacterizationMap implements Map<String, Comparer>{
	public static enum saveMode {
		SAVE_ON_MODIFICATION /* This may lead to slow performance with large test objects*/,
		SAVE_ON_EXPLICIT_CALL /* The drawback of this is that you have to remember to save */
	};

	// ==============
	// STATIC METHODS
	// ==============

	public static CharacterizationMap getDefaultMap() {
		return CharacterizationTestUtils.DEFAULT_CHARACTERIZATION;
	}

	// ===============
	// INSTANCE FIELDS
	// ===============

	protected Map<String, Comparer> map = new HashMap<String, Comparer>();
	protected File baseDirectory;
	protected String relFilePath;
	protected final saveMode mode;
	private File file;

	// ============
	// CONSTRUCTORS
	// ============

	public CharacterizationMap(saveMode mode, File sourceFile) {
		this.file =  sourceFile;
		this.mode = (mode == null)? saveMode.SAVE_ON_MODIFICATION: mode;
		Properties props = new Properties();
		try {
			if (!file.exists()) {
				boolean status = file.createNewFile();
				if (!status) {
					throw new ExceptionInInitializerError("Unable to create properties file for recording characterizations");
				}
			} else {

				FileReader reader = new FileReader(file);
				try {
					props.load(reader);
					load(props);
				} catch (Exception e) {
					System.out.println("Unable to load file " + file.getPath() + " as properties file");
				} finally {
					try {
						reader.close();
					} catch (Exception e) {
						// ignore
					}
				}
			}
		} catch (IOException e) {
			// TODO: handle exception
		}
	}

	// ================
	// INSTANCE METHODS
	// ================
	public void load() throws IOException {
		Properties props = new Properties();
		Reader fr = new FileReader(file);
		props.load(fr);
		load(props);
	}

	public void load(Properties props) {
		assert(props != null);
		for (Entry<Object, Object> entry: props.entrySet()) {
			String key = entry.getKey().toString();
			String value = entry.getValue().toString();
			try {
				Comparer comparer = Comparer.deserialize(value);
				map.put(key, comparer);
			} catch (ClassNotFoundException e) {
				System.err.println(String.format("Unable to deserialize value [%s] for key %s", value, key));
				e.printStackTrace();
			}
		}
	}
	public void save() throws IOException {
		Properties props = new Properties();
		for (Entry<String, Comparer> entry: map.entrySet()) {
			props.setProperty(entry.getKey(), entry.getValue().serialize());
		}
		Writer writer = new FileWriter(file);
		props.store(writer, "Saved Characterization Test values for " + file.getName());
	}


	// =====================
	// MAP INTERFACE METHODS
	// =====================
	public void clear() {
		map.clear();
		saveOnPutRemoveAndClear("clear");
	}



	public boolean containsKey(Object key) {
		return map.containsKey(key);
	}

	public boolean containsValue(Object value) {
		return map.containsValue(value);
	}

	public Set<java.util.Map.Entry<String, Comparer>> entrySet() {
		return map.entrySet();
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == null) return false;
		if (! (obj instanceof CharacterizationMap)) return false;
		CharacterizationMap cm = (CharacterizationMap) obj;
		// This will work for now but needs further differentiation. It's too coarse for equals
		return map.equals(cm.map);
	}

	public Comparer get(Object key) {
		return map.get(key);
	}

	@Override
	public int hashCode() {
		return map.hashCode();
		// This will work for now but needs further differentiation later
	}

	public boolean isEmpty() {
		return map.isEmpty();
	}

	public Set<String> keySet() {
		return map.keySet();
	}

	public Comparer put(String key, Comparer value) {
		Comparer result = map.put(key, value);
		saveOnPutRemoveAndClear("put");
		return result;
	}

	public void putAll(Map<? extends String, ? extends Comparer> m) {
		map.putAll(m);
		saveOnPutRemoveAndClear("putAll");
	}

	public Comparer remove(Object key) {
		Comparer result = map.remove(key);
		saveOnPutRemoveAndClear("remove");
		return result;
	}

	public int size() {
		return map.size();
	}

	public Collection<Comparer> values() {
		return map.values();
	}

	// =======================
	// PRIVATE UTILITY METHODS
	// =======================
	protected void saveOnPutRemoveAndClear(String methodName) {
		if (mode == saveMode.SAVE_ON_MODIFICATION) {
			try {
				save();
			} catch (IOException e) {
				e.printStackTrace();
				throw new RuntimeException(methodName + "() with SAVE_ON_MODIFICATION was unable to save", e);
			}
		}
	}
}
