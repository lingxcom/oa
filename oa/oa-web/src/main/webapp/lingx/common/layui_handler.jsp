<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ page import="com.lingx.core.utils.Utils,com.lingx.core.model.bean.UserBean,com.lingx.core.service.*,com.lingx.core.Constants,com.lingx.core.service.*,com.lingx.core.model.*,java.util.*,com.alibaba.fastjson.JSON,org.springframework.context.ApplicationContext,org.springframework.web.context.support.WebApplicationContextUtils,org.springframework.jdbc.core.JdbcTemplate" %>

<%
	String cmd=request.getParameter("c");
ApplicationContext applicationContext = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
JdbcTemplate jdbc=applicationContext.getBean("jdbcTemplate",JdbcTemplate.class);
IWorkflowService wf=applicationContext.getBean(IWorkflowService.class);
ILingxService lingx=applicationContext.getBean(ILingxService.class);
//IActivitiService activitiService=applicationContext.getBean(IActivitiService.class);
UserBean userBean=(UserBean)session.getAttribute(Constants.SESSION_USER);
Map<String,Object> ret=new HashMap<String,Object>();
ret.put("success", true);
ret.put("code", 1);
ret.put("message", "操作成功");
if("tree_opertor".equals(cmd)){
	String ecode=request.getParameter("ecode");
	String id=request.getParameter("id");
	String title=request.getParameter("title");
	String type=request.getParameter("type");
	String field=request.getParameter("field");
	String newId=request.getParameter("newId");
	switch(type){
	case "add":
		jdbc.update("insert into "+ecode+"(id,fid,"+field+") values(?,?,?)",newId,id,"未命名");
		break;
	case "update":
		jdbc.update("update "+ecode+" set "+field+"=? where id=?",title,id);
		break;
	case "del":
		jdbc.update("delete from "+ecode+" where id=?",id);
		break;
	}
	out.println(JSON.toJSONString(ret));
}else{
	System.out.println("参数c的值["+cmd+"]有误,system/workflow/manager/handler.jsp");
}
%>