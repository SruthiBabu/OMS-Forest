package com.fahm.forest.utils;

import java.rmi.RemoteException;

import org.w3c.dom.Document;

import com.yantra.interop.japi.YIFApi;
import com.yantra.interop.japi.YIFClientCreationException;
import com.yantra.interop.japi.YIFClientFactory;
import com.yantra.yfc.util.YFCCommon;
import com.yantra.yfs.japi.YFSEnvironment;
import com.yantra.yfs.japi.YFSException;

public class FAHMApiUtils {

	public static Document callApi(YFSEnvironment env, Document inDoc, Document dTemplate, String sApiName) {

		Document dOutput = null;
		YIFApi localApi;
		
		try {
			localApi = YIFClientFactory.getInstance().getLocalApi();
			if (!YFCCommon.isVoid(dTemplate)) {
				env.setApiTemplate(sApiName, dTemplate);
			}
			dOutput = localApi.invoke(env, sApiName, inDoc);
		} catch (YIFClientCreationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (YFSException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		if (!YFCCommon.isVoid(dOutput)) {
			return dOutput;
		}
		return null;

	}

	public static Document callService(YFSEnvironment env, Document inDoc, Document dTemplate, String sApiName) {
		Document dOutput = null;
		YIFApi localApi;
		try {
			localApi = YIFClientFactory.getInstance().getLocalApi();
			if (!YFCCommon.isVoid(dTemplate)) {
				env.setApiTemplate(sApiName, dTemplate);
			}
			dOutput = localApi.executeFlow(env, sApiName, inDoc);
		} catch (YIFClientCreationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (YFSException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (!YFCCommon.isVoid(dOutput)) {
			return dOutput;
		}
		return null;
	}
}
