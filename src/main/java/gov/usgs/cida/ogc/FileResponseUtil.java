package gov.usgs.cida.ogc;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FileResponseUtil {

	/**
	 * Copies InputStream to OutputStream
	 * 
	 * @param input
	 * @param output
	 * @return
	 * @throws IOException
	 * [TODO] move this to a better location
	 */
	public static int copy(InputStream input, OutputStream output)
	            throws IOException {
	    byte[] buffer = new byte[8 << 5]; // 8k buffer size
	    int count = 0;
	    int n = 0;
	    while (-1 != (n = input.read(buffer))) {
	        output.write(buffer, 0, n);
	        count += n;
	    }
	    return count;
	}

	public static void filter(Map<String, String> replacementMap, BufferedReader reader, BufferedWriter writer) throws IOException {
		String line = null;
		while ( (line = reader.readLine()) != null) {
			Matcher matcher = REGEXREPLACE_PATTERN.matcher(line);
			StringBuffer filteredLineBuffer = new StringBuffer();
			while (matcher.find()) {
				String key = matcher.group(1);
				String value = replacementMap.get(key);
				if (value == null) {
					// if no key found in replacement map, just put back the original value
					value = matcher.group();
				}
				matcher.appendReplacement(filteredLineBuffer, value);
			}
			matcher.appendTail(filteredLineBuffer);
			writer.append(filteredLineBuffer);
			writer.newLine();
		}
		writer.flush();
	}

	public static BufferedReader wrapAsBufferedReader(InputStream inputStream) {
		return new BufferedReader(new InputStreamReader(inputStream));
	}

	public static BufferedReader wrapAsBufferedReader(Reader reader) {
		return reader instanceof BufferedReader ?
			(BufferedReader)reader :
			new BufferedReader(reader);
	}

	public static BufferedWriter wrapAsBufferedWriter(OutputStream outputStream) {
		return new BufferedWriter(new OutputStreamWriter(outputStream));
	}

	public static BufferedWriter wrapAsBufferedWriter(Writer writer) {
		return writer instanceof BufferedWriter ?
			(BufferedWriter)writer :
			new BufferedWriter(writer);
	}

	public static void writeToStreamWithReplacements(String resource, OutputStream outputStream,
			Map<String, String> replacementMap, 
			String errorMessage) throws IOException {
		InputStream inputStream = FileResponseUtil.class.getResourceAsStream(resource);
		BufferedWriter writer = wrapAsBufferedWriter(new OutputStreamWriter(outputStream));
		try {
			if (inputStream != null) {
				filter (replacementMap,
						wrapAsBufferedReader(inputStream),
						writer);
			} else {
				writer.append(errorMessage);
			}
		} finally {
			writer.flush();
			if (inputStream != null) {
				try { inputStream.close(); } catch (IOException e) { }
		
			}
		}
	}

	public final static Pattern REGEXREPLACE_PATTERN = Pattern.compile("\\$\\{([\\w\\.]+)\\}");

}
