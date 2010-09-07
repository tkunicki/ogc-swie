package gov.usgs.cida.utils.collections;

import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * A Map implementation whose keys are in some canonical form. Conversion to the
 * canonical form is done automatically at lookup.
 * 
 * @author ilinkuo
 * 
 * @param <T>
 */
public abstract class CanonicalKeyMap<S, T> implements Map<S, T> {
	private final Map<S, T>  _backingMap;
	
	/**
	 * keys is to return the original key
	 */
	private final Set<S> keys;
	
	public CanonicalKeyMap(){
		_backingMap = new HashMap<S, T>();
		keys = new HashSet<S>();
	};
	
	public CanonicalKeyMap(int size){
		_backingMap = new HashMap<S, T>(size);
		keys = new HashSet<S>(size);
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
		return _backingMap.containsKey(toCanonicalKey(key));
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
		// return the original keys
		return Collections.unmodifiableSet(keys);
	}

	@Override
	public T put(S key, T value) {
		S canonicalKey = toCanonicalKey(key);
		if (!_backingMap.containsKey(canonicalKey)) {
			// This helps to cut down on the occurrence of different forms of
			// the same key, but does not completely prevent it
			keys.add(key);
		}
		
		// Note that keys.add() may != _backingMap.put()
		// Not sure if this is something I need to worry about
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
		// Note that this does not remove all the variants of a canonical key,
		// but the possibility of that happening is reduced by the code in put(). 
		// Not sure if I really need to worry about this.
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

	@Override
	public String toString() {
		return _backingMap.toString();
	}
	
	
	
	


}
