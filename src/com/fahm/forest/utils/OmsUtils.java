package com.fahm.forest.utils;

import java.util.HashMap;

import org.w3c.dom.Document;

import com.yantra.yfc.dom.YFCDocument;
import com.yantra.yfc.dom.YFCElement;
import com.yantra.yfc.util.YFCCommon;
import com.yantra.yfs.japi.YFSEnvironment;

public class OmsUtils {
	private static HashMap<String, String> _properties;

	public static synchronized void clearMap() {
		_properties = new HashMap<String, String>();
	}
	
	public static synchronized String getPropertyValue(YFSEnvironment env, String sProperty, String sCategory) {
		if (YFCCommon.isVoid(_properties)) {
			_properties = new HashMap<String, String>();
		}
		if (!_properties.containsKey(sProperty)) {

			YFCDocument input = YFCDocument.createDocument("GetProperty");
			YFCElement eInput = input.getDocumentElement();
			eInput.setAttribute("PropertyName", sProperty);
			if(!YFCCommon.isVoid(sCategory)) {
				eInput.setAttribute("Category", sCategory);
			}

			try {
				Document dResponse = FAHMApiUtils.callApi(env, input.getDocument(), null, "getProperty");
				_properties.put(sProperty, dResponse.getDocumentElement().getAttribute("PropertyValue"));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return _properties.get(sProperty);
	}
}
