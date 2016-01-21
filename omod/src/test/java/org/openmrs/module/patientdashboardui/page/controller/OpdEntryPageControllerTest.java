package org.openmrs.module.patientdashboardui.page.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.mock.MockHttpServletResponse;
import org.junit.Test;
import org.openmrs.ui.framework.BasicUiUtils;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.openmrs.ui.framework.session.Session;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpSession;

public class OpdEntryPageControllerTest {
	
	private static final String TEST_CONTEXT_PATH = "openmrs";

	private PageRequest createPageRequest(HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
		HttpServletRequest request = (httpRequest != null) ? httpRequest : new MockHttpServletRequest();
		HttpServletResponse response = (httpResponse != null) ? httpResponse : new MockHttpServletResponse();
		return new PageRequest(null, null, request, response, new Session(new MockHttpSession()));
	}
	
	private final UiUtils uiUtils = new UiUtils() {

		@Override
		public String pageLink(String providerName, String pageName) {
			return new BasicUiUtils().pageLink(providerName, pageName);
		}

		@Override
		public String message(String code, Object... args) {
			return null;
		}
	};

	@Test
	public void testPost() throws Exception {
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.setContextPath(TEST_CONTEXT_PATH + "/patientdashboardui/opdEntry.page");
		PageRequest pageRequest = createPageRequest(request, null);
		HttpSession httpSession = new MockHttpSession();
		request.setSession(httpSession);

		PageModel pageModel = new PageModel();
		//new OpdEntryPageController().post(17, null, new Integer[] { 1202 }, new Integer[] { 1041 }, request, uiUtils);
		//new LoginPageController().get(pageModel, uiUtils, pageRequest, null, null, appFrameworkService);

		//assertEquals(redirectUrl, pageModel.get(REQUEST_PARAMETER_NAME_REDIRECT_URL));
	}

}
