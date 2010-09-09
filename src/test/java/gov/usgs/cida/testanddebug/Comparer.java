package gov.usgs.cida.testanddebug;

public class Comparer {
	public static Class<?> DEFAULT_CLASS = String.class;

	public static Comparer deserialize(String value) throws ClassNotFoundException {
		int valuePos = 0 + "{objValue:".length();
		int classMarker = value.indexOf("objClass:");
		int classPos = classMarker + "objClass:".length();
		int hashCodeMarker = value.indexOf("objHashCode:");
		int hashCodePos = hashCodeMarker + "objHashCode:".length();

		boolean isNull = hashCodeMarker < 0;

		if (isNull) {
			return new Comparer(null);
		}
		String oValue = value.substring(valuePos, classMarker - 2); // -2 to ignore the ,\n before the objClass
		String oClassName = value.substring(classPos, hashCodeMarker - 2); // -2 to ignore the ,\n before the objClass
		String oHashString = value.substring(hashCodePos, value.length() - 1); // -1 to ignore ending brace
		int oHashCode = Integer.parseInt(oHashString);

		Class<?> oClass = Comparer.class.getClassLoader().loadClass(oClassName);
		return new Comparer(oValue, oClass, oHashCode);
	}

	public final String objValue;
	public final Class<?> objClass;
	public final int objHashCode;

	private Comparer(String value, Class<?> clazz, int hashCode) {
		this.objValue = value;
		this.objClass = clazz;
		this.objHashCode = hashCode;
	}

	public Comparer(Object obj) {
		if (obj != null) {
			objClass = obj.getClass();
			objValue = obj.toString();
			objHashCode = obj.hashCode();
		} else {
			objValue = null;
			objClass = DEFAULT_CLASS;
			objHashCode = 0;
		}
	}

	public boolean compare(Object anotherObj){
		if (anotherObj != null && objValue != null){
			return (anotherObj.getClass().equals(objClass)
					&& objHashCode == anotherObj.hashCode()
					&& objValue.equals(anotherObj.toString()));
		}
		return anotherObj == null && objValue == null;
	}

	@Override
	public String toString() {
		return objValue;
	}

	@Override
	public int hashCode() {
		return objHashCode;
	}

	@Override
	public boolean equals(Object obj) {
		return compare(obj);
	}

	public String serialize() {
		if (objValue == null) {
			return String.format("{objClass:%s}", objClass.getCanonicalName());
		}
		return String.format("{objValue:%s,\nobjClass:%s,\nobjHashCode:%s}", objValue, objClass.getCanonicalName(), objHashCode);
	}


}
