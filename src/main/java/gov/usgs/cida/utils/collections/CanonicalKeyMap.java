package gov.usgs.cida.utils.collections;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * A Map implementation whose keys are case insensitive. Does not allow null keys.
 * @author ilinkuo
 *
 * @param <T>
 */
public abstract class CanonicalKeyMap<S, T> implements Map<S, T> {
	private final Map<S, T>  _backingMap;
	private final Set<S> keys = new HashSet<S>();
	
	public CanonicalKeyMap(){
		_backingMap = new HashMap<S, T>();
	};
	
	public CanonicalKeyMap(int size){
		_backingMap = new HashMap<S, T>(size);
	};
	
	// utility method
	public abstract S toCanonicalKey(Object key);
	
	// Interface methods
	@Override
	public void clear() {
		_backingMap.clear();
	}

	@Override
	public boolean containsKey(Object key) {
		return keys.contains(toCanonicalKey(key));
	}

	@Override
	public boolean containsValue(Object value) {
		return _backingMap.containsValue(value);
	}

	@Override
	public Set<java.util.Map.Entry<S, T>> entrySet() {
		return _backingMap.entrySet();
	}

	@Override
	public T get(Object key) {
		return _backingMap.get(toCanonicalKey(key));
	}

	@Override
	public boolean isEmpty() {
		return _backingMap.isEmpty();
	}

	@Override
	public Set<S> keySet() {
		return _backingMap.keySet();
	}

	@Override
	public T put(S key, T value) {
		S canonicalKey = toCanonicalKey(key);
		keys.add(canonicalKey);
		return _backingMap.put(canonicalKey, value);

	}

	/**
	 *
	 * @see java.util.Map#putAll(java.util.Map)
	 * Note: null keys are ignored
	 */
	@Override
	public void putAll(Map<? extends S, ? extends T> m) {
		// Probably not the most efficient way of doing this
		for ( S key: m.keySet()) {
			put(key, m.get(key));
		}
	}

	@Override
	public T remove(Object key) {
		S canonicalKey = toCanonicalKey(key);
		keys.remove(key);
		return _backingMap.remove(canonicalKey);
	}

	@Override
	public int size() {
		return _backingMap.size();
	}

	@Override
	public Collection<T> values() {
		return _backingMap.values();
	}
	
	


}
