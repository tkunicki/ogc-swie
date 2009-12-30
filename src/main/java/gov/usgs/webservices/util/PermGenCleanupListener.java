package gov.usgs.webservices.util;

import java.lang.reflect.Method;
import java.sql.Driver;
import java.sql.DriverManager;
import java.util.Enumeration;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class PermGenCleanupListener implements ServletContextListener {

	public PermGenCleanupListener() {
	}
	
	public void contextInitialized(ServletContextEvent sce) {
	}

	public void contextDestroyed(ServletContextEvent sce) {
    	try {
    		for (Enumeration<?> e = DriverManager.getDrivers(); e.hasMoreElements(); ) {
    			Driver driver = (Driver) e.nextElement();
    			if (driver.getClass().getClassLoader() == getClass().getClassLoader()) {
    				try {
    					DriverManager.deregisterDriver(driver);
    					System.out.println("INFO:  deregistered driver:" + driver.getClass().getName());
    				} catch (Exception ex) {
    					System.out.println("ERROR: failed deregistered driver:" + driver.getClass().getName() + ", " + e);
    				}
    			}
    		}
    	} catch (Exception e) {
    		System.out.println("Unable to enumerate JDBC drivers: " + e);
    	}
    	

    	ClassLoader contextClassLoader = Thread.currentThread().getContextClassLoader();
    	
    	Class<?> clazz = null;
    	Method method = null;
    	
    	//// Apache Commons Logging
    	// org.apache.commons.logging.LogFactory.release(contextClassLoader);
    	try {
    		clazz = Class.forName("org.apache.commons.logging.LogFactory", false, contextClassLoader);
    		if (clazz != null) {
//    			System.out.println("INFO:  Apache commons-logging, attempting call to org.apache.commons.logging.LogFactory.release(...)");
    			method = clazz.getMethod("release", ClassLoader.class);
    			if (method != null) {
    				try {
    					method.invoke(null, contextClassLoader);
//    	    			System.out.println("INFO:  Apache commons-logging, called org.apache.commons.logging.LogFactory.release(...)");
    				} catch (Exception e) {
    					System.out.println("ERROR: Apache commons-logging, call to org.apache.commons.logging.LogFactory.release(...) failed! " + e);
    				}
    			} else {
    				System.out.println("ERROR: Apache commons-logging, release(...) not found!");
    			}
    		} else {
//    			System.out.println("INFO:  Apache commons-logging not encountered");
    		}
    	} catch (ClassNotFoundException e) {
//    		System.out.println("INFO:  Apache commons-logging not encountered");
    	} catch (Exception e) {
    		System.out.println("ERROR? Apache commons-logging unable to load class for release");
    	}
		
    	//// Log4J
 		// org.apache.log4j.LogManager.shutdown();
    	try {
    		clazz = Class.forName("org.apache.log4j.LogManager", false, contextClassLoader);
    		if (clazz != null) {
//    			System.out.println("INFO:  Log4J, attempting call to org.apache.log4j.LogManager.shutdown()");
    			method = clazz.getMethod("shutdown", (Class[]) null);
    			if (method != null) {
    				try {
    					method.invoke(null, (Object[]) null);
//    	    			System.out.println("INFO:  Log4J, called org.apache.log4j.LogManager.shutdown()");
    				} catch (Exception e) {
    					System.out.println("ERROR: Log4J, call to org.apache.log4j.LogManager.shutdown() failed! " + e);
    				}
    			} else {
    				System.out.println("ERROR:Log4J, shutdown() not found!");
    			}
    		} else {
//    			System.out.println("INFO:  Apache Log4J not encountered");
    		}
    	} catch (ClassNotFoundException e) {
//    		System.out.println("INFO:  Apache Log4J not encountered");
    	} catch (Exception e) {
    		System.out.println("ERROR? Apache Log4J unable to load class for shutdown");
    	}

 		// java.util.logging, always present...
    	try {
    		java.util.logging.LogManager.getLogManager().reset();
//    		System.out.println("INFO:  java.util.logging.LogManager.getLogManager() called");
    	} catch (Exception e) {
    		System.out.println("ERROR: java.util.logging.LogManager.getLogManager() failed! " + e);
    	}
 
    	// Beans Introspection (iBatis?, Spring?)
    	try {
    		java.beans.Introspector.flushCaches();
//    		System.out.println("INFO:  java.beans.Introspector.flushCaches() called");
    	} catch (Exception e) {
    		System.out.println("ERROR: java.beans.Introspector.flushCaches() failed! " + e);
    	}
    }
}
