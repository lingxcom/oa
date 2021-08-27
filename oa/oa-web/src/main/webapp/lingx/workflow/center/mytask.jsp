<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ page import="com.lingx.core.utils.Utils,com.lingx.core.model.bean.UserBean,com.lingx.core.service.*,com.lingx.core.Constants,com.lingx.core.service.*,com.lingx.core.model.*,java.util.*,com.alibaba.fastjson.JSON,org.springframework.context.ApplicationContext,org.springframework.web.context.support.WebApplicationContextUtils,org.springframework.jdbc.core.JdbcTemplate" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	org.springframework.context.ApplicationContext spring = org.springframework.web.context.support.WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
	com.lingx.core.service.II18NService i18n=spring.getBean(com.lingx.core.service.II18NService.class);
	ILingxService lingx=spring.getBean(ILingxService.class);
	if(session.getAttribute(Constants.SESSION_USER)==null)return;
	UserBean userBean=(UserBean)session.getAttribute(Constants.SESSION_USER);
	int count1=lingx.queryForInt("select count(*) from tlingx_wf_instance_task t,tlingx_wf_instance a,tlingx_user b where b.id=a.user_id and t.instance_id=a.id and t.user_id=? and t.status=2 and a.status<>3  order by t.stime desc",userBean.getId());
	request.setAttribute("c1",count1);
	
	int count2=lingx.queryForInt("select count(*) from tlingx_wf_instance_task t,tlingx_wf_instance a,tlingx_wf_define_task b,tlingx_user c where c.id=a.user_id and t.instance_id=a.id and t.task_id=b.id and t.status=1 and a.status<>3  and t.user_id regexp '"+userBean.getId()+"' order by t.create_time desc");
	request.setAttribute("c2",count2);

	int count3=lingx.queryForInt("select count(*) from tlingx_wf_instance_task t,tlingx_wf_instance a,tlingx_user b where b.id=a.user_id and t.instance_id=a.id and t.user_id=? and a.user_id<>?  and t.status in(3,4) and a.status<>3  order by t.stime desc",userBean.getId(),userBean.getId());
	request.setAttribute("c3",count3);
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>实时监控</title>
<%@ include file="/lingx/include/include_JavaScriptAndCssByLayui.jsp"%> 
<style type="text/css">
.uline{
text-decoration: underline;
}
.layui-table-click{
background-color:#d2fbdd !important;

}

.layui-table-view{
margin:0px 0px 0px 0px;
border-bottom:0px none;
}
</style>
</head>
<body style="height:100%;border:0px none;">
<table style="width:99%;height:100%;margin:0px;padding:0px;border:0px none;">
<tr>
<td  valign="top" width="201">
<div style="width:200px;height:100%;border-right:1px solid #eee;overflow:auto;overflow-x:hidden;margin:0px;padding:0px;">
 <ul class="layui-menu" id="demo1">
   <li class="layui-menu-item-checked" onclick="closeLI(this,'getWorkflowListByDBLayui')" style="text-align:center;"><div class="layui-menu-body-title">待办任务(${c1 })</div></li>
   <li onclick="closeLI(this,'getWorkflowListByDLLayui')"><div class="layui-menu-body-title"  style="text-align:center;">待领任务(${c2 })</div></li>
   <li onclick="closeLI(this,'getWorkflowListByXGLayui')"><div class="layui-menu-body-title"  style="text-align:center;">历史任务(${c3 })</div></li>     
</ul>
</div>
</td><td valign="top" align="left">
<div id="searchBar" style="height:40px;line-height:40px;padding-left:10px;">
<div class="layui-btn-container"><div class="layui-inline" style="font-size:14px;margin:0px 10px 0px 0px;">流程名称</div> 
<div class="layui-inline"><input class="layui-input layui-input-sm lingx-search-ipt" style="font-size:14px;width:100px;height:30px;margin:0px 10px 0px 0px;" name="name" onkeypress="lingxSearchIptKeypress(event)" autocomplete="off"></div>
<button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="lingx-search" style="margin-bottom:0px;" onclick="lingxSearch()">搜索</button></div>
</div>
<table class="layui-hide" id="test" lay-filter="test" ></table>

</td>
</tr>
</table>
 
<script type="text/html" id="barDemo">
  <a class="layui-btn layui-btn-xs btn_A" lay-event="edit">打开</a>
  <a class="layui-btn layui-btn-xs btn_A" lay-event="wt">委托</a>
</script>
              
          
 
<script>
var handlerJsp="lingx/workflow/center/handler.jsp";
var table,json;

layui.use('table', function(){
   table = layui.table;
	var columns=[{title:"流程名称",field: 'workflow'},
		{title:"当前任务节点",field: 'task_name',width:150},
		{title:"任务到达时间",field: 'task_time',width:200,templet:function(obj){
			return ft(obj.task_time);
		}},
		{title:"流程发起人",field: 'user_name',width:150},
		{title:"流程发起时间",field: 'wf_time',width:200,templet:function(obj){
			return ft(obj.wf_time);
		}}
		];
	
	columns.push( {fixed: 'right', title:'操作', toolbar: '#barDemo', width:180});
	 var tableIns =table.render({
		    elem: '#test'
		    ,url:handlerJsp+'?c=getWorkflowListByDBLayui'
		    ,height:'full-40'
	 		,title: '数据列表'
		    ,cols: [columns]
		    ,page: true
		  });
	 		table.on('row(test)', function(obj){
		    var data = obj.data;
		    //标注选中样式
		    obj.tr.addClass('layui-table-click').siblings().removeClass('layui-table-click');
		    
		  });
		  table.on('rowDouble(test)', function(obj){
			  var data = obj.data;  //获取当前点击的节点数据
			  openFullWindow("w?m=form&_TASK_ID="+data.id);
			});
		  table.on('tool(test)', function(obj){
		    var data = obj.data;
		    if(obj.event === 'edit'){
		    	openFullWindow("w?m=form&_TASK_ID="+data.id);
		    } else if(obj.event === 'wt'){
		    	lgxInfo("打开流程，在左上角“操作”里可委托他人代办")
		    }
		  });
		  
});

function lingxSearchIptKeypress(e){
	if(e.keyCode==13){
		lingxSearch();
	}
}
function lingxSearch(){
	var ipts=$(".lingx-search-ipt");
	var params={isGridSearch:"_true"};
	//console.log(ipts);
	for(var i=0;i<ipts.length;i++){
		var el=$(ipts[i]);
		if(el.val())
		params[el.attr("name")]=el.val();
	}
//alert("lingx-search:"+JSON.stringify(params));
table.reload('test', {page: {
    curr: 1 //重新从第 1 页开始
},where:params});
}
function reloadGrid(){
	table.reload('test', {
        
      });
}
function ft(time){
	return time.substring(0,4)+"-"+time.substring(4,6)+"-"+time.substring(6,8)+" "+time.substring(8,10)+":"+time.substring(10,12)+":"+time.substring(12,14);
}
function closeLI(el,index){
	table.reload('test', {
		url:handlerJsp+'?c='+index
    });
	
}
</script>
</body>
</html>