package reporteExplosionProductos;

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "org.joda.time.DateTime"%>
<%@ page import="com.cofar.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%! Connection con=null;
%>
<%
con =Util.openConnection(con);   
%>

<%!
public double redondear( double numero, int decimales ) {
    return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
}
%>
<%!
public double compara(int unidad1,int unidad2){
    String nombre_material="",nombre_unidad_medida="",nombre_unidad_medida2="";
    
    double valor_equivalencia=1;
    try{
        String sql="select cod_unidad_medida,cod_unidad_medida2,valor_equivalencia";
        sql+=" from equivalencias";
        sql+=" where cod_unidad_medida="+unidad1;
        sql+=" and cod_unidad_medida2="+unidad2;
        sql+=" and cod_estado_registro=1";
        System.out.println("sql:1***********"+sql);
        Statement st= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql);
        int sw=0;
        double equivalencia=0;
        while (rs.next()){
            equivalencia=rs.getDouble(3);
            sw=1;
        }
        if(sw==1){
            valor_equivalencia=1/equivalencia;
        }else{
            String sql2="select cod_unidad_medida,cod_unidad_medida2,valor_equivalencia";
            sql2+=" from equivalencias";
            sql2+=" where cod_unidad_medida="+unidad2;
            sql2+=" and cod_unidad_medida2="+unidad1;
            sql2+=" and cod_estado_registro=1";
            System.out.println("sql:2***********"+sql2);
            Statement st2= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs2 = st2.executeQuery(sql2);
            sw=0;
            while (rs2.next()){
                sw=1;
                equivalencia=rs2.getDouble(3);
            }
            if(sw==1){
                valor_equivalencia=equivalencia;
            }
        }
    } catch(SQLException e) {
        e.printStackTrace();
    }
    System.out.println("valor_equivalencia:"+valor_equivalencia);
    return valor_equivalencia;
}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>  
         function enviarForm(f)
         {   //sacar el valor del multiple
                /***** CAPITULO ******/
                f.cod_capitulo.value=f.cod_capitulo.value;
                /*************************** GRUPOS  *************************/
                /*var arrayGrupos=new Array();
                var j=0;
		for(var i=0;i<=f.cod_grupo.options.length-1;i++)
		{	if(f.cod_grupo.options[i].selected)
			{	arrayGrupos[j]=f.cod_grupo.options[i].value;
                                //arrayLineaMkt1[j]=f.cod_grupo.options[i].innerHTML;
				j++;
			}
		}                
                f.codGrupos.value=arrayGrupos;   
                */
                /*************************** ITEMS *************************/
                var arrayItem=new Array();
                //var arrayCliente1=new Array();
		var j=0;
		for(var i=0;i<=f.cod_item.options.length-1;i++)
		{	if(f.cod_item.options[i].selected)
			{	arrayItem[j]=f.cod_item.options[i].value;
                                //arrayCliente1[j]=f.cod_item.options[i].innerHTML;
				j++;
			}
		}                           
                f.codItems.value=arrayItem;
                //f.nombreCliente.value=arrayCliente1;  
 
                /*alert(arrayGrupos);
                alert(arrayItem);
                alert("capitulo:"+f.cod_capitulo.value);
                alert("grupo:"+f.codGrupos.value);
                alert("item:"+f.codItems.value);*/
                /*----- ajax  --------------*/
                var ajax=nuevoAjax();
                var url='../reporteExplosionProductos/reporteExplosionProductos.jsf';
                var url2='codigo1='+f.cod_prog.value;
                url2+='&codigo3='+f.codItems.value;
                url2+='&fecha_inicio='+f.fechaInicioPrograma.value;
                url2+='&fecha_final='+f.fechaFinalPrograma.value;
                url2+='&fecha_inicio_promedio='+f.fecha_inicio.value;
                url2+='&fecha_final_promedio='+f.fecha_final.value;
                url2+='&pq='+(Math.random()*1000);
                
                ajax.open ('post', url, true);
                ajax.onreadystatechange = function() {
                   if (ajax.readyState==1) {

                   }else if(ajax.readyState==4){
                        if(ajax.status==200){
                            var panel=document.getElementById('panel');
                            panel.innerHTML=ajax.responseText;

                        }
                   }
                }
                ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
                ajax.send(url2);

                
                
                
                
        }    
        function retornarAtras(f){           
           location.href='planillaSubsidio.jsp';
        }
        function guardar(f){           
           f.submit();
        }
        function nuevoAjax()
            {	var xmlhttp=false;
                try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                    try {
 			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        	xmlhttp = false;
                    }                    
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                       xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
            }
     function grupo(codigo){
     //alert();
            
        var ajax=nuevoAjax();
        var url='../reporteExplosionProductos/explosionGrupoajax.jsp?codigo='+codigo;
        url+='&pq='+(Math.random()*1000);
        ajax.open ('GET', url, true);
        ajax.onreadystatechange = function() {
           if (ajax.readyState==1) {
            
           }else if(ajax.readyState==4){
                if(ajax.status==200){
                  //alert(ajax.responseText);
                    var mainGrupo=document.getElementById('mainGrupo');
                    mainGrupo.innerHTML=ajax.responseText;
                    f=0;
                    Item(codigo,f);
                }
           }
        }
        ajax.send(null);
    }
    
    function Item(codigo,f){
       
        var ajax=nuevoAjax();
        if(f==0){
           codGrupo=0;
            //alert(codGrupo);
        }else{
           //alert(f.cod_capitulo.value);  
        // var codGrupo=document.getElementById('cod_capitulo').value;
            var codGrupo=f.cod_grupo.value;
            codigo=f.cod_capitulo.value;
            //alert(codigo);
            var arrayGrupo=new Array();                
	    var j=0;
	    for(var i=0;i<=f.cod_grupo.options.length-1;i++)
	    {	
                if(f.cod_grupo.options[i].selected)
		{
                    arrayGrupo[j]=f.cod_grupo.options[i].value;                                
		    j++;
		}
	    } 
            codGrupo=arrayGrupo;
        }
        
        //alert(codGrupo);
        var url='../reporteExplosionProductos/explosionItemajax.jsp?codigo='+codigo+'&cod_grupo='+codGrupo;
        url+='&pq='+(Math.random()*1000);
        ajax.open ('GET', url, true);
        ajax.onreadystatechange = function() {
           if (ajax.readyState==1) {
            
           }else if(ajax.readyState==4){
                if(ajax.status==200){
                      //alert(ajax.responseText);
                      var mainItem=document.getElementById('mainItem');
                      mainItem.innerHTML=ajax.responseText;
                }
          }
        }
        ajax.send(null);
    }
    
     function sel_todoItem(f){
        var arrayItem=new Array();
        var j=0;
        for(var i=0;i<=f.cod_item.options.length-1;i++)
        {   if(f.chk_Item.checked==true)
            {   f.cod_item.options[i].selected=true;
                arrayItem[j]=f.cod_item.options[i].value;
                j++;
            }
            else
            {   f.cod_item.options[i].selected=false;
            }
        }
      }
        </script>
    </head>
    <body>
        <form name="form1" action="reporteExplosionProductos.jsp" method="post">
            <%            
            String sql="";
            String sql1="";
            String sql2="";
            String sql3="";
            String sql4="";
            String sql5="";
            String cod_capitulo="";
            String nombre_capitulo="";
            String cod_beneficiario="";
            String nombre_beneficiario="";
            String cod_subsidio="";
            String nombre_subsidio="";
            String monto_subsidio="";
            String codProgramaProd=request.getParameter("codigos");
            String fechaInicio=request.getParameter("fecha_inicio");
            String fechaInicioVector[]=fechaInicio.split(",");
            fechaInicioVector=fechaInicioVector[0].split("/");
            fechaInicio=fechaInicioVector[2]+"/"+fechaInicioVector[1]+"/"+fechaInicioVector[0];
            String fechaFinal=request.getParameter("fecha_final");
            String fechaFinalVector[]=fechaFinal.split(",");
            fechaFinalVector=fechaFinalVector[0].split("/");
            fechaFinal=fechaFinalVector[2]+"/"+fechaFinalVector[1]+"/"+fechaFinalVector[0];
            System.out.println("codProgramaProd:"+codProgramaProd);
            System.out.println("fechaInicio:"+fechaInicio);
            System.out.println("fechaFinal:"+fechaFinal);
            %>            
            
            <h4 align="center">Explosión de Materiales</h4>
            <br>
            <table width="65%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="1" cellspacing="1">
                <tr class="headerClassACliente">                     
                    <td  colspan="3" align="center" class=colh style="border : solid #f2f2f2 0px;">Filtrar Por</td>
                </tr>                             
                <tr class="border">
                    <td >Capítulo  </td>
                    <td >::</td>
                    <td >
                        <%
                        try{
                            sql5="select cod_capitulo,nombre_capitulo from capitulos";
                            sql5+=" where cod_estado_registro=1 order by nombre_capitulo";
                            Statement st5= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs5 = st5.executeQuery(sql5);
                        %>                         
                        <select name="cod_capitulo" class="inputText2" onchange ="grupo(this.value)" id="cod_capitulo"> 
                            <%                            
                            while (rs5.next()) {
                                cod_capitulo=rs5.getString("cod_capitulo");
                                nombre_capitulo=rs5.getString("nombre_capitulo");
                            %>
                            <option value="<%=cod_capitulo%>"><%=nombre_capitulo%></option>
                            <%                           
                            }
                            %>                             
                        </select>
                        <%                        
                        } catch(Exception e) {
                        }               
                        %> 
                    </td>
                </tr>   
                <tr class="border">
                    <td >Grupos</td>
                    <td >::</td>
                    <td >
                        <div id="mainGrupo">
                            <select name="cod_grupo" class="inputText2"  multiple>
                                <option>Seleccione una opcion
                            </select>
                        </div>
                    </td>
                </tr>  
                <tr class="border">
                    <td >Item</td>
                    <td >::</td>
                    <td >
                        <div id="mainItem">
                            <select name="cod_item" class="inputText2" multiple>
                                <option>Seleccione una opcion
                            </select>
                            
                        </div>
                        
                    </td>
                </tr>   
                <tr>
                    <td>
                        Fecha Inicio Promedio
                    </td>
                    <td >::</td>
                    <td>
                        <input type="text"  size="12"  value="" name="fecha_inicio" class="inputText">
                        <img id="imagenFecha1" src="../img/fecha.bmp">
                        <DLCALENDAR tool_tip="Seleccione la Fecha"
                                    daybar_style="background-color: DBE1E7; 
                                    font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;" 
                                    input_element_id="fecha_inicio"; click_element_id="imagenFecha1">
                                    </DLCALENDAR>            
                    </td> 
                </tr>
                <tr>
                    <td>
                        Fecha Final Promedio
                    </td>
                    <td >::</td>
                    <td>
                        <input type="text"  size="12"  value="" name="fecha_final" class="inputText">
                        <img id="imagenFecha2" src="../img/fecha.bmp">
                        <DLCALENDAR tool_tip="Seleccione la Fecha"
                                    daybar_style="background-color: DBE1E7; 
                                    font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;" 
                                    input_element_id="fecha_final"; click_element_id="imagenFecha2">
                                    </DLCALENDAR>            
                    </td> 
                </tr>
            </table>
            <input type="hidden" name="codGrupos">
            <input type="hidden" name="codItems">
            <input type="hidden" name="fechaInicioPrograma" value="<%=fechaInicio%>">
            <input type="hidden" name="fechaFinalPrograma" value="<%=fechaFinal%>">
            <br>
            <div align="center">                
                <input type="button"  class="btn" value="Ver" name="ab" onClick="enviarForm(form1)">
                
            </div>
            
            <%  
            try{
                String cod_grupos=request.getParameter("codGrupos");
                cod_capitulo=request.getParameter("cod_capitulo");
                String cod_items=request.getParameter("codItems");
                Date fechaActual=new Date();
                SimpleDateFormat f=new SimpleDateFormat("yyyy/MM/dd");
                String fecha_existencia=f.format(fechaActual);
                //String capitulo=" and c.cod_capitulo in ("+cod_capitulo+")";
                //String grupos=" and g.cod_grupo in ("+cod_grupos+")";
                String items=" and m.cod_material in (";
                codProgramaProd=codProgramaProd+"0";
            /*String codProgramaProdVector[]=codProgramaProd.split(",");
            System.out.println("codProgramaProdVector.length:"+codProgramaProdVector.length);
            for(int i=0;i<=codProgramaProdVector.length;i++){
            System.out.println("codProgramaProdVector[]:"+codProgramaProdVector[i]);
            }*/
                sql4="select ppd.COD_MATERIAL,sum(ppd.CANTIDAD) from PROGRAMA_PRODUCCION_DETALLE ppd";
                sql4+=" where ppd.COD_PROGRAMA_PROD in ("+codProgramaProd+")  group by ppd.cod_material";
                System.out.println("sql4:"+sql4);
                Statement st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs4 = st4.executeQuery(sql4);
                while(rs4.next()){
                    items+=rs4.getString(1)+",";
                    System.out.println("item44:"+items);
                }
                items+="0)";
                System.out.println("item:"+items);
            /* AQ_auxiliarconsultas2.SQL.Clear;
            AQ_auxiliarconsultas2.SQL.Add('delete from reporte_explosion_materiales where cod_persona='+inttostr(codigo_personal)+'";
            AQ_auxiliarconsultas2.ExecSQL;*/
                
                /* --------------------   APROBADOS ----------------------*/
                String sql_exp="";
                sql_exp="select m.cod_material,m.stock_minimo_material,m.stock_maximo_material,m.stock_seguridad,m.cod_unidad_medida,m.nombre_material,u.nombre_unidad_medida,";
                sql_exp+=" (select SUM(iade.cantidad_parcial) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
                sql_exp+=" WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='"+lcb_almacen.KeyValue+"'";
                sql_exp+=" and ia.fecha_ingreso_almacen<='"+fecha_existencia+"' )as aprobados,";
                /* --------------------   SALIDAS ----------------------*/
                sql_exp+=" (select SUM(sadi.cantidad)";
                sql_exp+=" from salidas_almacen_detalle sad,salidas_almacen_detalle_ingreso sadi,ingresos_almacen_detalle_estado iade, salidas_almacen sa";
                sql_exp+=" WHERE sa.cod_salida_almacen=sad.cod_salida_almacen and sa.estado_sistema=1 and sa.cod_estado_salida_almacen=1 and";
                sql_exp+=" sad.cod_salida_almacen=sadi.cod_salida_almacen and sad.cod_material=sadi.cod_material and";
                sql_exp+=" sadi.cod_ingreso_almacen=iade.cod_ingreso_almacen and sadi.cod_material=iade.cod_material and sadi.ETIQUETA=iade.ETIQUETA ";
                //
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and sa.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                //else sql_exp+="and (sa.cod_almacen=1 or sa.cod_almacen=2)";
                sql_exp+=" and sad.cod_material=m.cod_material and sa.fecha_salida_almacen<='"+fecha_existencia+"')as salidas,";
                /* --------------------   DEVOLUCIONES ----------------------*/
                sql_exp+="(select sum(iad.cant_total_ingreso_fisico) from DEVOLUCIONES d, ingresos_almacen ia,INGRESOS_ALMACEN_DETALLE iad";
                sql_exp+=" where ia.cod_devolucion=d.cod_devolucion and ia.fecha_ingreso_almacen<='"+fecha_existencia+"' and d.cod_estado_devolucion=1 and d.estado_sistema=1 and ia.cod_estado_ingreso_almacen=1";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+="and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+' and d.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                sql_exp+=" and ia.cod_almacen=d.cod_almacen and ia.cod_ingreso_almacen=iad.cod_ingreso_almacen and iad.cod_material=m.cod_material)as devoluciones,";
                /* --------------------   CUARENTENA ----------------------*/
                sql_exp+=" (select SUM(iade.cantidad_restante)";
                sql_exp+=" from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
                sql_exp+=" WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
                sql_exp+=" and iade.cod_estado_material=1 and ia.fecha_ingreso_almacen<='"+fecha_existencia+"')as cuarentena,";
                /* --------------------   RECHAZADO ----------------------*/
                sql_exp+=" (select SUM(iade.cantidad_restante)";
                sql_exp+=" from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
                sql_exp+=" WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
                sql_exp+=" and iade.cod_estado_material=3 and ia.fecha_ingreso_almacen<='"+fecha_existencia+"')as rechazado,";
                /* --------------------   VENCIDO ----------------------*/
                sql_exp+=" (select SUM(iade.cantidad_restante)";
                sql_exp+=" from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
                sql_exp+=" WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
                sql_exp+=" and iade.cod_estado_material=4 and ia.fecha_ingreso_almacen<='"+fecha_existencia+"'  )as vencido,";
                /* --------------------   OBSOLETO ----------------------*/
                sql_exp+=" (select SUM(iade.cantidad_restante)";
                sql_exp+=" from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
                sql_exp+=" WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
                sql_exp+=" and iade.cod_estado_material=5 and ia.fecha_ingreso_almacen<='"+fecha_existencia+"')as obsoleto,";
                sql_exp+=" (select sum (rd.CANTIDAD ) from RESERVA r,RESERVA_DETALLE rd " ;
                sql_exp+=" where r.NRO_OP=rd.NRO_OP and rd.COD_MATERIAL = m.COD_MATERIAL ) as reserva" ;
                
                
                sql_exp+=" from materiales m,grupos g,capitulos c,UNIDADES_MEDIDA u " ;
                sql_exp+=" where m.cod_grupo=g.cod_grupo and g.cod_capitulo=c.cod_capitulo and  m.material_almacen=1 and u.cod_unidad_medida=m.cod_unidad_medida ";
                sql_exp+= items;
                sql_exp+=" order by m.nombre_material";
                System.out.println("sql_exp:"+sql_exp);
            /*AQ_stockmateriales.SQL.Add(sql_1+sql_2);
            if(rbt_con.Checked=true)then sql_exp+="and  m.movimiento_item=1";
            if(rbt_sin.Checked=true)then sql_exp+="and  m.movimiento_item=2";
            sql_exp+=" and m.nombre_material like ''%'+edt_nombrematerial.Text+'%''";
 
            sql_exp+=" and m.cod_estado_registro=1 order by m.nombre_material,c.nombre_capitulo,g.nombre_grupo";
            //edit1.Text:=AQ_stockmateriales.SQL.Text;
            AQ_stockmateriales.Open;
            //             Edit1.Text:=AQ_stockmateriales.SQL.Text;
 
             */     %>
            
            <DIV ALIGN="CENTER" CLASS="outputText2" >
                <br>
                <br>
                <b> Detalle de Explosión de Materiales</b>
                <br>
                <br>
                
                <table width="60%" align="center" class="outputText2">
                    <tr>
                        <td>Normal : </td>
                        <td bgcolor="#F5D2F3" width="12%" >&nbsp;</td>
                        <td>Faltante : </td>
                        <td bgcolor="#FC8585" width="12%">&nbsp;</td>
                        <td>Pedido : </td>
                        <td bgcolor="#CDF6F8" width="12%">&nbsp;</td>
                        <td>En Tránsito: </td>
                        <td bgcolor="#B4F5B6" width="12%">&nbsp;</td>
                    </tr>
                </table>
            </DIV>
            <DIV ALIGN="CENTER" CLASS="outputText2" ID="panel">
                <br>
                <br>
                <input type="hidden" id="item" name="item" value="<%=items%>">
                <input type="hidden" id="cod_prog" name="cod_prog" value="<%=codProgramaProd%>">
                <table width="80%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="1" cellspacing="1">
                    <tr class="headerClassACliente">  
                        <th  align="center" style="border : solid #f2f2f2 1px;">Nro</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Material</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Stock Min</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Stock Max</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Stock Seg</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Unid. Med.</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Consumo Prom</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Aprob</th>
                        <%--th  align="center" style="border : solid #f2f2f2 1px;">Salidas</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Devol</th--%>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Cuar</th>
                        <%--th  align="center" style="border : solid #f2f2f2 1px;">Rech</th--%>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Venc</th>
                        <%--th  align="center" style="border : solid #f2f2f2 1px;">Obsoletos</th--%>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Reserva</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Disponible</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">A Utilizar Prod.</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Diferencia</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Pedido</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Tránsito</th>
                        
                        
                    </tr>  
                    <%
                    Statement st2= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs2 = st2.executeQuery(sql_exp);
                    int count=0;
                    while(rs2.next()){
                        System.out.println("erer");
                        String codMaterial=rs2.getString(1);
                        double stockMinimo=rs2.getDouble(2);
                        stockMinimo=redondear(stockMinimo,3);
                        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat form = (DecimalFormat)nf;
                        form.applyPattern("#,###.00");
                        String stock_minimo=form.format(stockMinimo);
                        double stockMaximo=rs2.getDouble(3);
                        stockMaximo=redondear(stockMaximo,3);
                        String stock_maximo=form.format(stockMaximo);
                        double stockSeguridad=rs2.getDouble(4);
                        stockSeguridad=redondear(stockSeguridad,3);
                        String stock_segu=form.format(stockSeguridad);
                        String cod_unidadMedida=rs2.getString(5);
                        String nombreMaterial=rs2.getString(6);
                        String nombreUnidadMedida=rs2.getString(7);
                        double aprobados=rs2.getDouble(8);
                        aprobados=redondear(aprobados,3);
                        
                        double salidas=rs2.getDouble(9);
                        salidas=redondear(salidas,3);
                        String salida=form.format(salidas);
                        double devoluciones=rs2.getDouble(10);
                        devoluciones=redondear(devoluciones,3);
                        String devolucion=form.format(devoluciones);
                        double cuarentena=rs2.getDouble(11);
                        cuarentena=redondear(cuarentena,3);
                        String cuaren=form.format(cuarentena);
                        double rechazado=rs2.getDouble(12);
                        rechazado=redondear(rechazado,3);
                        String recha=form.format(rechazado);
                        double vencido=rs2.getDouble(13);
                        vencido=redondear(vencido,3);
                        String venc=form.format(vencido);
                        double obsoleto=rs2.getDouble(14);
                        obsoleto=redondear(obsoleto,3);
                        String obso=form.format(obsoleto);
                        double reserva=rs2.getDouble(15);
                        reserva=redondear(reserva,3);
                        String reser=form.format(reserva);
                        double total=aprobados-salidas+devoluciones-rechazado-vencido-obsoleto-reserva;
                        total=redondear(total,3);
                        String disponible=form.format(total);
                        aprobados=aprobados-salidas+devoluciones-rechazado-vencido-obsoleto-reserva-cuarentena;
                        aprobados=redondear(aprobados,3);
                        String aprob=form.format(aprobados);
                        
                        count++;
                        
                        sql4="select r.CANTIDAD from RESERVA_DETALLE r " ;
                        sql4+=" where r.NRO_OP in ("+codProgramaProd+") and r.COD_MATERIAL='"+codMaterial+"' " ;
                        System.out.println("sql4:"+sql4);
                        st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs4 = st4.executeQuery(sql4);
                        double cantReservado=0;
                        while(rs4.next()){
                            cantReservado=rs4.getDouble(1);
                        }
                        
                        sql4="select ppd.COD_MATERIAL,sum(ppd.CANTIDAD) from PROGRAMA_PRODUCCION_DETALLE ppd";
                        sql4+=" where ppd.COD_PROGRAMA_PROD in ("+codProgramaProd+") and ppd.cod_material='"+codMaterial+"'  group by ppd.cod_material";
                        System.out.println("sql4:"+sql4);
                        st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs4 = st4.executeQuery(sql4);
                        double cantidadProd=0;
                        String produccion="";
                        while(rs4.next()){
                            cantidadProd=rs4.getDouble(2);
                            cantidadProd=redondear(cantidadProd,2);
                            cantidadProd=cantidadProd-cantReservado;
                            produccion=form.format(cantidadProd);
                            System.out.println("entor cantidad:"+cantidadProd);
                            
                        }
                        sql4="select oc.fecha_emision,oc.cod_orden_compra,oc.cod_moneda,ocd.cod_unidad_medida,";
                        sql4+=" precio_unitario,cantidad_neta,um.NOMBRE_UNIDAD_MEDIDA";
                        sql4+=" from ordenes_compra_detalle ocd,ORDENES_COMPRA oc,UNIDADES_MEDIDA um";
                        sql4+=" where oc.cod_orden_compra = ocd.cod_orden_compra and oc.COD_ESTADO_COMPRA = 13 AND";
                        sql4+=" oc.ESTADO_SISTEMA = 1 and oc.FECHA_ENTREGA>='"+fechaInicio+"' AND oc.FECHA_ENTREGA<='"+fechaFinal+"' AND um.COD_UNIDAD_MEDIDA=ocd.cod_unidad_medida and";
                        sql4+=" cod_material='"+codMaterial+"'  order by oc.FECHA_EMISION asc";
                        System.out.println("sql4:"+sql4);
                        st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs4 = st4.executeQuery(sql4);
                        double cantidad_neta=0;
                        String unidad_medida="";
                        int cod_unidad_medida_pedido=0;
                        String pedido="";
                        while(rs4.next()){
                            cod_unidad_medida_pedido=rs4.getInt(4);
                            cantidad_neta=rs4.getDouble(6);
                            unidad_medida=rs4.getString(7);
                            
                            double equivalencia=compara(Integer.parseInt(cod_unidadMedida),cod_unidad_medida_pedido);
                            cantidad_neta=cantidad_neta*equivalencia;
                            cantidad_neta=redondear(cantidad_neta,3);
                            pedido=form.format(cantidad_neta);
                            System.out.println("entor cantidad:"+cantidad_neta);
                        }
                        sql4="select oc.fecha_emision,oc.cod_orden_compra,oc.cod_moneda,ocd.cod_unidad_medida,";
                        sql4+=" precio_unitario,cantidad_neta-cantidad_ingreso_almacen,um.NOMBRE_UNIDAD_MEDIDA";
                        sql4+=" from ordenes_compra_detalle ocd,ORDENES_COMPRA oc,UNIDADES_MEDIDA um";
                        sql4+=" where oc.cod_orden_compra = ocd.cod_orden_compra and oc.COD_ESTADO_COMPRA IN (5,6) AND";
                        sql4+=" oc.ESTADO_SISTEMA = 1 and oc.FECHA_ENTREGA>='"+fechaInicio+"' AND oc.FECHA_ENTREGA<='"+fechaFinal+"' AND um.COD_UNIDAD_MEDIDA=ocd.cod_unidad_medida and";
                        sql4+=" cod_material='"+codMaterial+"'  order by oc.FECHA_EMISION asc";
                        System.out.println("sql4:"+sql4);
                        st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs4 = st4.executeQuery(sql4);
                        double cantidad_neta_transito=0;
                        String unidad_medida_transito="";
                        int cod_unidad_medida_compra=0;
                        String transito="";
                        while(rs4.next()){
                            cod_unidad_medida_compra=rs4.getInt(4);
                            cantidad_neta_transito=rs4.getDouble(6);
                            unidad_medida_transito=rs4.getString(7);
                            double equivalencia=compara(Integer.parseInt(cod_unidadMedida),cod_unidad_medida_compra);
                            cantidad_neta_transito=cantidad_neta_transito*equivalencia;
                            cantidad_neta_transito=redondear(cantidad_neta_transito,3);
                            transito=form.format(cantidad_neta_transito);
                            System.out.println("entor cantidad:"+cantidad_neta_transito);
                        }
                    
                    
                    %>
                    
                    <tr >
                        <td   style="border : solid #f2f2f2 1px;"><%=count%></td>
                        <td   style="border : solid #f2f2f2 1px;"><%=nombreMaterial%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=stock_minimo%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=stock_maximo%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=stock_segu%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=nombreUnidadMedida%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;">0.00</td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=aprob%></td>
                        <%--td  align="right" style="border : solid #f2f2f2 1px;"><%=salida%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=devolucion%></td--%>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=cuaren%></td>
                        <%--td align="right" style="border : solid #f2f2f2 1px;"><%=recha%></td--%>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=venc%></td>
                        <%--td  align="right" style="border : solid #f2f2f2 1px;"><%=obso%></td--%>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=reser%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"  ><%=disponible%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;" ><%=produccion%></td>
                        <%
                        double diferencia=total-cantidadProd;
                        diferencia=redondear(diferencia,2);
                        String diference=form.format(diferencia);
                        if(total<cantidadProd){
                        %>
                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#FC8585"><%=diference%></td>
                        <%
                        }else{
                        %>
                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#F5D2F3"><%=diference%></td>
                        <%
                        }
                        %>
                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#CDF6F8"><%=pedido%></td>
                        
                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#B4F5B6"><%=transito%></td>
                        
                    </tr>
                    <%
                    }
            } catch(SQLException e) {
                e.printStackTrace();
            }   
                    %> 
                </table>
            </div>
            
            <%--h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedProgramaProduccion.Cancelar}"/--%>
        </form>
        
        
        
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>
