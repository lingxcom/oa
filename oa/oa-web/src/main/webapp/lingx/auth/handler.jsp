<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ page import="com.lingx.core.utils.Utils,com.lingx.core.model.bean.UserBean,com.lingx.core.service.*,com.lingx.core.Constants,com.lingx.core.service.*,com.lingx.core.model.*,java.util.*,com.alibaba.fastjson.JSON,org.springframework.context.ApplicationContext,org.springframework.web.context.support.WebApplicationContextUtils,org.springframework.jdbc.core.JdbcTemplate" %>
<%!
public List<Map<String,Object>> treeMenu(String fid,String roleid,JdbcTemplate jdbc){
	List<Map<String,Object>> list=jdbc.queryForList("select id,name title from tlingx_menu where fid=? order by orderindex asc",fid);
	for(Map<String,Object> m:list){
		m.put("checked", jdbc.queryForObject("select count(*) from tlingx_rolemenu where role_id=? and menu_id=?", Integer.class,roleid,m.get("id"))>0);
		m.put("field","none");
		m.put("spread","0".equals(fid));
		List<Map<String,Object>> listsub=treeMenu(m.get("id").toString(),roleid,jdbc);
		if(listsub.size()>0){
			m.put("children",listsub);
			m.put("checked",false);
		}
	}
	return list;
}

public List<Map<String,Object>> treeFunc(String fid,String roleid,JdbcTemplate jdbc){
	List<Map<String,Object>> list=jdbc.queryForList("select id,name title from tlingx_func where fid=? order by name asc",fid);
	for(Map<String,Object> m:list){
		m.put("checked", jdbc.queryForObject("select count(*) from tlingx_rolefunc where role_id=? and func_id=?", Integer.class,roleid,m.get("id"))>0);
		m.put("field","none");
		m.put("spread","0".equals(fid));
		List<Map<String,Object>> listsub=treeFunc(m.get("id").toString(),roleid,jdbc);
		if(listsub.size()>0){
			m.put("children",listsub);
			m.put("checked",false);
		}
	}
	return list;
}
%>
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
if("menu_tree".equals(cmd)){
	String roleid=request.getParameter("roleid");
	List<Map<String,Object>> tree=treeMenu("0",roleid,jdbc);
	ret.put("data",tree);
	out.println(JSON.toJSONString(ret));
}else if("menu_save".equals(cmd)){
	String roleid=request.getParameter("roleid");
	String menuids=request.getParameter("menuids");
	String array[]=menuids.split(",");
	jdbc.update("delete from tlingx_rolemenu where role_id=?",roleid);
	//System.out.println(array.length);
	for(String menuid:array){
		jdbc.update("insert into tlingx_rolemenu(id,role_id,menu_id)values(uuid(),?,?)",roleid,menuid);
	}
	out.println(JSON.toJSONString(ret));
}else if("func_tree".equals(cmd)){
	String roleid=request.getParameter("roleid");
	List<Map<String,Object>> tree=treeFunc("0",roleid,jdbc);
	ret.put("data",tree);
	out.println(JSON.toJSONString(ret));
}else if("func_save".equals(cmd)){
	String roleid=request.getParameter("roleid");
	String funcids=request.getParameter("funcids");
	String array[]=funcids.split(",");
	jdbc.update("delete from tlingx_rolefunc where role_id=?",roleid);
	//System.out.println(array.length);
	for(String funcid:array){
		jdbc.update("insert into tlingx_rolefunc(id,role_id,func_id)values(uuid(),?,?)",roleid,funcid);
	}
	out.println(JSON.toJSONString(ret));
}else{
	System.out.println("参数c的值["+cmd+"]有误,"+request.getServletPath());
}
%>