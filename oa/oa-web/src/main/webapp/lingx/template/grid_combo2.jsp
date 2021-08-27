<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	org.springframework.context.ApplicationContext spring = org.springframework.web.context.support.WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
	com.lingx.core.service.II18NService i18n=spring.getBean(com.lingx.core.service.II18NService.class);
	String text="";
	if(request.getParameter("text")!=null)text=java.net.URLDecoder.decode(request.getParameter("text"),"UTF-8");
	request.setAttribute("reqText",text);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>实体列表</title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<%@ include file="/lingx/include/include_JavaScriptAndCssByLayui.jsp"%> 
<style type="text/css">
.item_checked{
background-color: #5FB878!important;
color: #fff!important;
-webkit-user-select:none;
-moz-user-select:none;
-ms-user-select:none;
user-select:none;
}

.layui-table-view{
margin:0px;
}
</style>
</head>
<body style="height:100%">
<table style="width:100%;height:100%">
<tr>
<td  valign="top">
<div style="width:170px;height:100%;border-right:1px solid #eee;overflow:auto;overflow-x:hidden;">
 <ul class="layui-menu" id="demo1">
      
        
</ul>
</div>
</td><td valign="top">

<div id="searchBar" style="height:40px;line-height:40px;padding-left:10px;"></div>
<table class="layui-hide" id="test" lay-filter="test" ></table>

</td>
</tr>
</table>

 
<script type="text/html" id="toolbarDemo">
<!--
  <div class="layui-btn-container">
    <button class="layui-btn layui-btn-sm" lay-event="getCheckData">获取选中行数据</button>
    <button class="layui-btn layui-btn-sm" lay-event="getCheckLength">获取选中数目</button>
    <button class="layui-btn layui-btn-sm" lay-event="isAll">验证是否全选</button>
  </div>
 -->
</script>
 
<script type="text/html" id="barDemo"><!--
  <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
  <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>-->
</script>
              
          
 
<script>

var request_params=${REQUEST_PARAMS};

var fromPageId='${param.pageid}';
var entityCode=request_params.e;
var methodCode=request_params.m;
var entityId='${entityId }';
var params=${_params};

var cmpId='${param.cmpId}';
var LingxOpertor='${param.LingxOpertor}';

var table,json,toolHeight=0;

var oldtext="${reqText}";
var oldvalue="${param.value}";

layui.use('table', function(){
   table = layui.table;
  $.post("g",{e:entityCode},function(json1){
	json=eval("(" + json1 + ')');
	//console.log(json);
	var columns=json.columns,columnsNew=[];
	for(var i=0;i<columns.length;i++){
		var obj=columns[i];
		obj.field=obj.dataIndex;
		obj.title=obj.header;
		obj.templet=obj.renderer;
		

		if(!json.GridConfig.gridFields||(","+json.GridConfig.gridFields+",").indexOf(","+obj.dataIndex+",")>=0){
			if(i<5){
				columnsNew.push(obj);
			}
		}
	}
	columns=columnsNew;
	
	for(var i=0;i<json.fields.list.length;i++){
		var obj=json.fields.list[i];
		if(obj.comboType=='ref-display')textField=obj.code;
		if(obj.comboType=='ref-value')valueField=obj.code;
	}
	columns.unshift( {type: 'checkbox', fixed: 'left'});
	//columns.push( {fixed: 'right', title:'操作', toolbar: '#barDemo', width:200});
	/////////////////////////////////
	var toolbar=json.toolbar;
	var queryParams=json.queryParams;
	var html=$('<div class="layui-btn-container"></div>');
	for(var i=0;i<queryParams.length;i++){
		var obj=queryParams[i];
		html.append('<div class="layui-inline" style="font-size:14px;margin:0px 10px 0px 0px;">'+obj.name+'</div> ');
		html.append('<div class="layui-inline">'+
			    '<input class="layui-input layui-input-sm lingx-search-ipt" style="font-size:14px;width:100px;height:30px;margin:0px 10px 0px 0px;" name="'+obj.code+'" onkeypress="lingxSearchIptKeypress(event)" autocomplete="off">'+
			    '</div> ');
	}
	if(queryParams.length>0){
		html.append('<button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="lingx-search" style="margin-bottom:0px;" onclick="lingxSearch()">搜索</button>');
		$("#searchBar").append(html);
		toolHeight=40;
	}else{
		$("#searchBar").remove();
		toolHeight=0;
	}
	
	html=$('<div class="layui-btn-container"></div>');
	for(var i=0;i<toolbar.length;i++){
		var obj=toolbar[i];
		$("#barDemo").append('<a class="layui-btn layui-btn-xs '+("删除"==obj.text?"layui-btn-danger":"")+'" lay-event="'+obj.code+'">'+obj.text+'</a>');
		if(obj.currentRow){
		}else{
			html.append('<button class="layui-btn layui-btn-sm" lay-event="'+obj.code+'">'+obj.text+'</button>');
		}
	}
	
	$("#toolbarDemo").append(html);
	 var tableIns =table.render({
		    elem: '#test'
		    ,url:Lingx.urlAddParams("e?e="+entityCode+"&m=grid&lgxsn=1&retType=layui",params)
		    //,toolbar: toolbar.length>0?'#toolbarDemo':"" //开启头部工具栏，并为其绑定左侧模板
		    ,defaultToolbar: toolbar.length>0?['filter', 'exports', 'print']:[]
		    /*
		    ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
		      title: '提示'
		      ,layEvent: 'LAYTABLE_TIPS'
		      ,icon: 'layui-icon-tips'
		    }]
		    */  
		    ,width:548
		    ,height:'full-'+toolHeight
	 		,title: '数据列表'
		    ,cols: [columns]
		    ,page: true
		  });
		  
		  //头工具栏事件
		  table.on('toolbar(test)', function(obj){
			  for(var i=0;i<toolbar.length;i++){
				  var o=toolbar[i];
				  if(o.code==obj.event){
					  o.handler();
					  return;
				  }
			  }
		    var checkStatus = table.checkStatus(obj.config.id);
		    switch(obj.event){
		    	case 'lingx-search':
		    		
		    	break;
		      case 'getCheckData':
		        var data = checkStatus.data;
		        layer.alert(JSON.stringify(data));
		      break;
		      case 'getCheckLength':
		        var data = checkStatus.data;
		        layer.msg('选中了：'+ data.length + ' 个');
		      break;
		      case 'isAll':
		        layer.msg(checkStatus.isAll ? '全选': '未全选');
		      break;
		      
		      //自定义头工具栏右侧图标 - 提示
		      case 'LAYTABLE_TIPS':
		        layer.alert('这是工具栏右侧自定义的一个图标按钮');
		      break;
		    };
		  });
		  
		  //监听行工具事件
		  table.on('tool(test)', function(obj){
			  window.CurrentData=[obj];
			  for(var i=0;i<toolbar.length;i++){
				  var o=toolbar[i];
				  if(o.code==obj.event){
					  o.handler();
					  return;
				  }
			  }
		    var data = obj.data;
		    //console.log(obj)
		    if(obj.event === 'del'){
		      layer.confirm('真的删除行么', function(index){
		        obj.del();
		        layer.close(index);
		      });
		    } else if(obj.event === 'edit'){
		      layer.prompt({
		        formType: 2
		        ,value: data.email
		      }, function(value, index){
		        obj.update({
		          email: value
		        });
		        layer.close(index);
		      });
		    }
		  });
		  
		  table.on('rowDouble(test)', function(obj){
			  /*
			  var data = obj.data;  //获取当前点击的节点数据
		      var win=getFromWindow(fromPageId);
				win.lingxSet({cmpId:cmpId,text:obj.data[textField],value:obj.data.id});
				closeWindow();
				*/
			});
		  

		  table.on('checkbox(test)', function(obj){
			  if(obj.checked){
			  if(obj.type=="one"){
				  addItem(obj.data);
				}else{
				  var checkStatus = table.checkStatus('test')
			      ,data = checkStatus.data;
				  for(var i=0;i<data.length;i++){
					  addItem(data[i]);
				  }
			  } 
			  }
			  
			});
		  
		  if(oldtext){
			  var arr1=oldtext.split(",");
			  var arr2=oldvalue.split(",");
			  for(var i=0;i<arr1.length;i++){
				  var id=arr2[i],title=arr1[i];
				  var obj={id:id};
				  obj[textField]=title;
				  addItem(obj);
			      
			  }
		  }
  });//,"json"
 
});

function addItem(data){
	if($("#item_"+data.id).length>0){
  	  lgxInfo("该项已选择，双击左栏可删除！")
  	  return;
    }
	 $("#demo1").append('<li id="item_'+data.id+'" item-value="'+data.id+'" item-title="'+data[textField]+'" style="background-color:#5FB878!important"  class="item_checked" ondblclick="closeLI(this)"><div class="layui-menu-body-title">'+data[textField]+'</div></li>');
}

function lingxSubmit(){
	var els=$(".item_checked"),texts="",values="";
	for(var i=0;i<els.length;i++){
		texts+=$(els[i]).attr("item-title")+',';
		values+=$(els[i]).attr("item-value")+',';
	}
	if(els.length>0){
		texts=texts.substring(0,texts.length-1);
		values=values.substring(0,values.length-1);
	}
	var win=getFromWindow(fromPageId);
	win.lingxSet({cmpId:cmpId,text:texts,value:values});
	closeWindow();
}
function lingxSearchIptKeypress(e){
	//console.log(e);
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
		params[el.attr("name")]="_"+el.val();
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

function closeLI(el){
	$(el).remove();
}
</script>
</body>

</html>