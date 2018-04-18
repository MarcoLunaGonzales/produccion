

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
<%! Connection con = null;
    String CadenaAreas = "";
    String areasDependientes = "";
    String sw = "0";
%>

<%
        con = Util.openConnection(con);
%>
<%!    public int numDiasMes(int mes, int anio) {
        int dias = 31;
        switch (mes) {
            case 2:
                
            case 4:
            case 6:
            case 9:
            case 11:
                dias = 30;
                break;
        }
        return dias;
    }
%>  


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
            function cambia(f){
                f.codGrupo.value=null;
                f.action="";
                f.submit();
            }
            function cambia1(f){
                //f.codGrupo.value=null;
                f.action="";
                f.submit();
            }
            function cambia2(f){
                //f.codGrupo.value=null;
                f.action="";
                f.submit();
            }
            function busqueda(f){
                var dependencias=document.getElementById('dependencias');
                var valor=dependencias.checked;
                //alert(f.sexo.value);
                location.href="navegadorPlanillaTributaria.jsp?cod_area_empresa="+f.cod_area_empresa.value+"&valor="+valor+"&cod_planilla_trib="+f.cod_planilla_trib.value;
            }
            /*function cargar(){
             document.getElementById('dependencias').checked=<%=request.getParameter("valor")%>;
          }*/
            function incluir_dependencias(f){
                var dependencias=document.getElementById('dependencias');
                var valor=dependencias.checked;
                //alert(f.sexo.value);
                //alert(dependencias.checked);
                //dependencias.checked=valor;
                location.href="navegadorPlanillaTributaria.jsp?cod_area_empresa="+f.cod_area_empresa.value+"&valor="+valor+"&cod_planilla_trib="+f.cod_planilla_trib.value;
                //alert(cod_area_empresa);
                //alert(valor);
            }
            function cancelar(){
                location.href="navegadorTipoIncentivoRegional.jsf";
            }

            /**
             * calcular
             */
            function calcular(f) {
                codigo=f.cod_tipo_incentivo_regional.value;
                location="rptCalculoMontoComisionCatA.jsf?cod_tipo_incentivo_regional="+codigo+"&nombre_gestion="+f.nombre_gestion.value+"&nombre_mes="+f.nombre_mes.value;
            }

            function eliminar1(f){
                var count1=0;
                var elements1=document.getElementById(f);
                var rowsElement1=elements1.rows;
                //alert(rowsElement1.length);
                for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                            if(cel1.getElementsByTagName('input')[0].checked){
                                count1++;
                            }
                        }
                    }

                }
                //alert(count1);
                if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
                }else{


                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;

                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                                //alert('No escogio ningun registro');
                                return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
            }



            function eliminar(f){
                alert(f.check.checked);
                alert(f.length);
                var codigo=new Array();
                var c=0;
                for(var i=0;i<f.length;i++){
                    if(f.elements[i].checked==true){
                        alert('entroor');
                        codigo[c]=f.check.value;
                        c++;
                    }
                }
                if(c==0){
                    alert('No escogio ningun registro');
                    return false;
                }else{
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            alert(codigo);
                            location.href="eliminarPlanillaSubsidioPersonal.jsf?codigo="+codigo+"&cod_planilla_subsidio="+f.cod_planilla_subsidio.value;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }

                }

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
            function guardarEvaluacionProveedor(codPeriodoEvaluacion){
                var tabla = document.getElementById("dataEvaluacionProveedor");
                var filas = tabla.rows;
                var ajax1 = new nuevoAjax();
                ajax1.open("GET","ajaxEliminarEvaluacionProveedores.jsf?codPeriodoEvaluacion="+codPeriodoEvaluacion+"&cod="+Math.random(),true);
                ajax1.send(null);
                for(var i=0;i<filas.length;i++){
                    //alert(filas[i].cells[0].innerHTML); //cells[0].innerHTML
                    if(filas[i].cells[0].getElementsByTagName("input")[0]!=null){
                        var codPeriodo = "0";
                        var codMaterial = filas[i].cells[0].getElementsByTagName("input")[0].value;
                        var codProveedor = filas[i].cells[0].getElementsByTagName("input")[1].value;
                        var codCategoriaProveedor = filas[i].cells[0].getElementsByTagName("input")[2].value;
                        var puntaje = filas[i].cells[0].getElementsByTagName("input")[3].value;
                        //var codPeriodoEvaluacion = filas[i].cells[0].getElementsByTagName("input")[4].value;
                        var fecha = filas[i].cells[0].getElementsByTagName("input")[5].value;
                        var codOrdenCompra = filas[i].cells[0].getElementsByTagName("input")[6].value;
                        var ajax=nuevoAjax();
                        ajax.open("GET","ajaxGuardarEvaluacionProveedores.jsf?codPeriodo="+codPeriodo+"&codMaterial="+codMaterial+"&codProveedor="+codProveedor+"&codCategoriaProveedor="+codCategoriaProveedor+"&puntaje="+puntaje+"&codPeriodoEvaluacion="+codPeriodoEvaluacion+"&fecha="+fecha+"&codOrdenCompra="+codOrdenCompra+"&cod="+Math.random(),true);
                        ajax.onreadystatechange=function(){
                            if (ajax.readyState==4) {
                                //div_lotes.innerHTML=ajax.responseText;
                            }
                        }
                        ajax.send(null);
                }
                    
                    //!=null?filas[i].cells[0].getElementsByName("codMaterial")[0].value:""
                    //var codProveedor = filas[i].cells[0].getElementsByName("codProveedor")[0].value;
                    //var codCategoriaProveedor = filas[i].cells[0].getElementsByName("codMaterial")[0].value;
                    //var puntaje = filas[i].cells[0].getElementsByName("puntaje")[0].value;
                    //var codPeriodoEvaluacion = filas[i].cells[0].getElementsByName("codPeriodoEvaluacion")[0].value;
                    
                    //var fecha = filas[i].getElementsByName("fecha")[0].cells[0].value;
                    //var codOrdenCompra = filas[i].cells[0].getElementsByName("codOrdenCompra")[0].value;
                    

                    //if(i==10){break;}

                    //alert(celda);                
            }
      }

        </script>
    </head>
    <body >
        <form name="form1" id="form1" action="filtroPresupuestos1.jsf" method="post" >

            <%!    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
            %>
            <%
        String codCapitulo = request.getParameter("codCapitulo");
        if (codCapitulo == null) {
            codCapitulo = "0";
        }
        String codGrupo = request.getParameter("codGrupo");
        if (codGrupo == null) {
            codGrupo = "0";
        }
        String codCategoria = request.getParameter("codCategoria");
        if (codCategoria == null) {
            codCategoria = "0";
        }

        String sql = "";
        String cod_gestion=request.getParameter("cod_gestion");
        String cod_mes=request.getParameter("cod_mes");
        String nom_gestion=request.getParameter("nombre_gestion");
        String nom_mes=request.getParameter("nombre_mes");
        String codPeriodoEvaluacion=request.getParameter("cod_tipo_inc_regional");
        System.out.println("codPeriodoEvaluacion:"+codPeriodoEvaluacion);
        String fecha_inicio = "";

        String fecha_inicioA = "";
        String fecha_final = "";
        String fecha_finalA = "";

        try{

        sql=" select isnull(t.FECHA_INICIO,'') as fecha_inicio,ISNULL(t.FECHA_FINAL, '') as fecha_final,g.NOMBRE_GESTION,m.NOMBRE_MES ";
        sql +=" from PERIODOS_EVALUACION_PROVEEDORES t,gestiones g ,meses m where t.COD_PERIODO_EVALUACION="+codPeriodoEvaluacion+" and g.COD_GESTION=t.COD_GESTION and m.COD_MES=t.COD_MES";
        System.out.println("sql FEchas" + sql);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql);
        int cont = 0;
        String stylo="";
        while (rs.next()) {
            fecha_inicio = rs.getString(1);
            String fecha_inicioV[]=fecha_inicio.split(" ");
            fecha_inicioV=fecha_inicioV[0].split("-");
            fecha_inicio=fecha_inicioV[2]+"/"+fecha_inicioV[1]+"/"+fecha_inicioV[0];
            System.out.println("fecha_inicio:"+fecha_inicio);
            fecha_inicioA = fecha_inicioV[0]+"/"+fecha_inicioV[1]+"/"+fecha_inicioV[2];
            fecha_final = rs.getString(2);
            nom_gestion = rs.getString(3);
            nom_mes = rs.getString(4);
            String fecha_finalV[]=fecha_final.split(" ");
            fecha_finalV=fecha_finalV[0].split("-");
            fecha_final=fecha_finalV[2]+"/"+fecha_finalV[1]+"/"+fecha_finalV[0];
            System.out.println("fecha_final:"+fecha_final);
            fecha_finalA = fecha_finalV[0]+"/"+fecha_finalV[1]+"/"+fecha_finalV[2];
        }
        
    } catch (SQLException e) {
            e.printStackTrace();
        }
            %>

            <div align="center" class="outputText2">
            <br> 
            <b><h3> Evaluacion de Proveedores </h3>
     
                <p align="center"> Gestión :<%=nom_gestion%>&nbsp;&nbsp; Mes :<%=nom_mes%></p>
                    
                <p align="center"> Fecha Inicio Periodo Evaluación :<%=fecha_inicio%>&nbsp <br><br>&nbsp; Fecha Final Periodo Evaluación :<%=fecha_final%></p>
            <br>
<%
        try {

            String sql0 = " select c.COD_CAPITULO,c.NOMBRE_CAPITULO from CAPITULOS c where c.COD_ESTADO_REGISTRO=1";
            System.out.println("sql:" + sql0);

            Statement st0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs0 = st0.executeQuery(sql0);

%><p class="outputText2">Capítulo :
    <select  name="codCapitulo" id="codCapitulo" class="inputText2" onchange="cambia(this.form);" >
        <option value="0"selected >TODOS</option>
        <%
    String cod = "";
    String nombre = "";
    while (rs0.next()) {
        System.out.println("paso ae:" + rs0.getString("NOMBRE_CAPITULO"));
        cod = rs0.getString("COD_CAPITULO");
        nombre = rs0.getString("NOMBRE_CAPITULO");
        if (codCapitulo.equals(cod)) {%>
        <option value="<%=cod%>"selected ><%=nombre%></option>
        <%  } else {%>
        <option value="<%=cod%>"><%=nombre%></option>
        <%}
    }
        %>
    </select>
</p>
<%

        //con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {

            String sql0 = " select cod_grupo,nombre_grupo from grupos where cod_capitulo in ( " + codCapitulo + ")";
            System.out.println("sql:" + sql0);

            Statement st0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs0 = st0.executeQuery(sql0);

%><p class="outputText2">Grupos :
    <select  name="codGrupo" id="codGrupo" class="inputText2" onchange="cambia1(this.form);" >
        <option value="0"selected >TODOS</option>
        <%
            String cod = "";
            String nombre = "";
            while (rs0.next()) {
                System.out.println("paso ae");
                cod = rs0.getString("cod_grupo");
                nombre = rs0.getString("nombre_grupo");
                if (codGrupo.equals(cod)) {%>
        <option value="<%=cod%>"selected ><%=nombre%></option>
        <%  } else {%>
        <option value="<%=cod%>"><%=nombre%></option>
        <%}
            }
        %>
    </select>
</p>
<%

        //con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {

            String sql0 = " select c.COD_CATEGORIA_PROVEEDOR,c.NOMBRE_CATEGORIA_PROVEEDOR from CATEGORIAS_PROVEEDOR c order by c.NOMBRE_CATEGORIA_PROVEEDOR";
            System.out.println("sql:" + sql0);

            Statement st0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs0 = st0.executeQuery(sql0);

%><p class="outputText2">Categoria Proveedor :
    <select  name="codCategoria" id="codCategoria" class="inputText2" onchange="cambia2(this.form);" >
        <option value="0"selected >TODOS</option>
        <%
            String cod = "";
            String nombre = "";
            while (rs0.next()) {
                System.out.println("paso ae");
                cod = rs0.getString("COD_CATEGORIA_PROVEEDOR");
                nombre = rs0.getString("NOMBRE_CATEGORIA_PROVEEDOR");
                if (codCategoria.equals(cod)) {%>
        <option value="<%=cod%>"selected ><%=nombre%></option>
        <%  } else {%>
        <option value="<%=cod%>"><%=nombre%></option>
        <%}
            }
        %>
    </select>
</p>
<%

        //con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
%>
            <br><br>

                <table width="89%" align="center" class="outputText2"  cellpadding="0" cellspacing="0">
                    <tr>
                       
                        <td width="10%" align="right">APROBADOS:&nbsp;</td>
                        <td width="10%" align="CENTER" bgcolor="GREEN" style="COLOR:#FFFFFF">&nbsp; > 70 %</td>
                       
                        <td width="10%" align="right">APROBADOS (RESERVA):&nbsp;</td>
                        <td width="10%" align="CENTER" bgcolor="ORANGE" style="COLOR:#FFFFFF">&nbsp; 56 - 69 %</td>
                        
                        <td width="10%" align="right">REPROBADOS:&nbsp;</td>
                        <td width="10%" align="CENTER" bgcolor="RED" style="COLOR:#FFFFFF">&nbsp; < 55 %</td>
                        
                        <td width="10%" align="right">NO EVALUADOS:&nbsp;</td>
                        <td width="10%" align="CENTER" bgcolor="#123789" style="COLOR:#FFFFFF">&nbsp;  SIN PUNTACION</td>
                       

                    </tr>
                </table>
            <br>
            <br>
            <table style="border:gray" width="89%" align="center" class="outputText2" cellpadding="0" cellspacing="0" id="dataEvaluacionProveedor">
                <tr class="headerClassACliente">

           
                    <td  height="35px" align="center" style="border-left : solid #333333 1px;border-top: solid #333333 1px;">&nbsp;</td>
                    <td  height="35px" align="center" style="border-left : solid #333333 1px;border-top: solid #333333 1px;">Proveedor</td>
                    <td  align="center" style="border-left : solid #333333 1px;border-top: solid #333333 1px;">Material</td>
                    <td  align="center" style="border-left : solid #333333 1px;border-top: solid #333333 1px;">Resultado</td>
                    <td  align="center" style="border-left : solid #333333 1px;border-top: solid #333333 1px;">Puntaje %</td>
                    <td  align="center" style="border-left : solid #333333 1px;border-top: solid #333333 1px;">Nro. O.C.</td>
                    <td  align="center" style="border-left : solid #333333 1px;border-top: solid #333333 1px;">Fecha Ingreso</td>
                    <td  align="center" style="border-left : solid #333333 1px;border-top: solid #333333 1px;">&nbsp;Evaluar Proveedor</td>
                    <td  align="center" style="border-left : solid #333333 1px;border-top: solid #333333 1px;">&nbsp;Imprimir Evaluación</td>

                </tr>
                <%


        try {
        String fecha_inicioV[]=fecha_inicio.split("/");
        fecha_inicio=fecha_inicioV[2]+"/"+fecha_inicioV[1]+"/"+fecha_inicioV[0];
        String fecha_finalV[]=fecha_final.split("/");
        fecha_final=fecha_finalV[2]+"/"+fecha_finalV[1]+"/"+fecha_finalV[0];
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

            /*sql = "SELECT DISTINCT O.COD_MATERIAL,M.NOMBRE_MATERIAL,P.NOMBRE_PROVEEDOR,P.COD_PROVEEDOR,  " ;
            sql += "(select isnull( cp.NOMBRE_CATEGORIA_PROVEEDOR,'') from  CATEGORIAS_PROVEEDOR cp,EVALUACION_PROVEEDORES_MATERIAL ep  WHERE cp.COD_CATEGORIA_PROVEEDOR=ep.COD_CATEGORIA_PROVEEDOR and ep.COD_PROVEEDOR=p.COD_PROVEEDOR and ep.COD_MATERIAL=m.COD_MATERIAL), " ;
            sql += "(select ep.PUNTUACION_TOTAL from  EVALUACION_PROVEEDORES_MATERIAL ep  WHERE ep.COD_PROVEEDOR=p.COD_PROVEEDOR and ep.COD_MATERIAL=m.COD_MATERIAL)" ;
            sql += " FROM ORDENES_COMPRA_DETALLE O,MATERIALES M,PROVEEDORES P  WHERE O.COD_ORDEN_COMPRA IN (";
            sql += " SELECT C.COD_ORDEN_COMPRA FROM ORDENES_COMPRA C WHERE C.COD_ESTADO_COMPRA IN (6,7,14,18) AND C.COD_PROVEEDOR=P.COD_PROVEEDOR";
            sql += " AND C.FECHA_EMISION>='2011/08/01' AND C.FECHA_EMISION<='2011/11/30') AND M.COD_MATERIAL=O.COD_MATERIAL AND M.COD_ESTADO_REGISTRO=1 AND M.MATERIAL_ALMACEN=1";
            sql += " AND P.COD_PROVEEDOR IN (SELECT OC.COD_PROVEEDOR FROM ORDENES_COMPRA OC WHERE OC.COD_ORDEN_COMPRA=O.COD_ORDEN_COMPRA)";
            sql += " AND M.COD_GRUPO IN (SELECT G.COD_GRUPO FROM GRUPOS G WHERE G.COD_CAPITULO IN (2,3,4,8))";
            sql += " ORDER BY P.NOMBRE_PROVEEDOR,M.NOMBRE_MATERIAL";*/
            sql = "SELECT DISTINCT O.COD_MATERIAL,M.NOMBRE_MATERIAL,P.NOMBRE_PROVEEDOR,P.COD_PROVEEDOR,  " ;
            sql += "(select isnull( cp.NOMBRE_CATEGORIA_PROVEEDOR,'') from  CATEGORIAS_PROVEEDOR cp,EVALUACION_PROVEEDORES_MATERIAL ep  WHERE cp.COD_CATEGORIA_PROVEEDOR=ep.COD_CATEGORIA_PROVEEDOR and ep.COD_PROVEEDOR=p.COD_PROVEEDOR and ep.COD_MATERIAL=m.COD_MATERIAL and ep.COD_PERIODO_EVALUACION='"+codPeriodoEvaluacion+"'), " ;
            sql += "(select isnull( cp.COD_CATEGORIA_PROVEEDOR,'') from  CATEGORIAS_PROVEEDOR cp,EVALUACION_PROVEEDORES_MATERIAL ep  WHERE cp.COD_CATEGORIA_PROVEEDOR=ep.COD_CATEGORIA_PROVEEDOR and ep.COD_PROVEEDOR=p.COD_PROVEEDOR and ep.COD_MATERIAL=m.COD_MATERIAL and ep.COD_PERIODO_EVALUACION='"+codPeriodoEvaluacion+"'), " ;
            sql += "(select ep.PUNTUACION_TOTAL from  EVALUACION_PROVEEDORES_MATERIAL ep  WHERE ep.COD_PROVEEDOR=p.COD_PROVEEDOR and ep.COD_MATERIAL=m.COD_MATERIAL and ep.COD_PERIODO_EVALUACION='"+codPeriodoEvaluacion+"')" ;
            sql += " FROM ORDENES_COMPRA_DETALLE O,MATERIALES M,PROVEEDORES P  WHERE O.COD_ORDEN_COMPRA IN (";
            sql += " SELECT C.COD_ORDEN_COMPRA FROM INGRESOS_ALMACEN C,INGRESOS_ALMACEN_DETALLE CD WHERE C.COD_TIPO_INGRESO_ALMACEN IN (1)  AND ";
            sql += " CD.COD_INGRESO_ALMACEN=C.COD_INGRESO_ALMACEN AND CD.COD_MATERIAL=O.COD_MATERIAL AND ";
            sql += " C.COD_PROVEEDOR = P.COD_PROVEEDOR AND C.FECHA_INGRESO_ALMACEN >= '"+fecha_inicio+"' AND C.FECHA_INGRESO_ALMACEN <= '"+fecha_final+"' and c.COD_ESTADO_INGRESO_ALMACEN <>2)";
            sql += " AND P.COD_PROVEEDOR IN (SELECT OC.COD_PROVEEDOR FROM ORDENES_COMPRA OC WHERE OC.COD_ORDEN_COMPRA=O.COD_ORDEN_COMPRA)";
            sql += " AND M.COD_GRUPO IN (SELECT G.COD_GRUPO FROM GRUPOS G WHERE G.COD_CAPITULO IN (2,3,4,8))";
            sql += " AND M.COD_MATERIAL = O.COD_MATERIAL AND M.COD_ESTADO_REGISTRO = 1 AND M.MATERIAL_ALMACEN = 1 ";
            //sql += " and epm.COD_MATERIAL=m.COD_MATERIAL and epm.COD_MATERIAL=o.COD_MATERIAL and epm.COD_PROVEEDOR=p.COD_PROVEEDOR and epm.COD_PERIODO_EVALUACION = '"+codPeriodoEvaluacion+"'  ";
            if (!codGrupo.equals("0")) {
                sql += " and m.cod_grupo=" + codGrupo;
            } else {
                if (codCapitulo.equals("0")) {
                } else {
                    sql += " and m.cod_grupo in (select cod_grupo from  grupos where cod_capitulo=" + codCapitulo + ")";
                }
            }
            if(!codCategoria.equals("0")){
                sql += " and P.COD_PROVEEDOR in (select ep.COD_PROVEEDOR from  CATEGORIAS_PROVEEDOR cp,EVALUACION_PROVEEDORES_MATERIAL ep";
                sql += " where ep.COD_CATEGORIA_PROVEEDOR= cp.COD_CATEGORIA_PROVEEDOR and ep.COD_PERIODO_EVALUACION="+codPeriodoEvaluacion+"";
                sql += " and cp.COD_CATEGORIA_PROVEEDOR="+codCategoria+" AND ep.COD_MATERIAL=m.COD_MATERIAL)";
            }

            /*if(!codCategoria.equals("0")){
                sql += " and epm.COD_CATEGORIA_PROVEEDOR="+codCategoria+"";
            }*/
            sql += " ORDER BY M.NOMBRE_MATERIAL,P.NOMBRE_PROVEEDOR";
            //sql += " ORDER BY P.NOMBRE_PROVEEDOR,M.NOMBRE_MATERIAL";
            sql =   " select m.COD_MATERIAL,m.NOMBRE_MATERIAL,p.NOMBRE_PROVEEDOR,p.COD_PROVEEDOR,e.PUNTUACION_TOTAL,cp.COD_CATEGORIA_PROVEEDOR,cp.NOMBRE_CATEGORIA_PROVEEDOR,oc.COD_ORDEN_COMPRA,oc.NRO_ORDEN_COMPRA " + //,ia.cod_ingreso_almacen,ia.fecha_ingreso_almacen
                    " from EVALUACION_PROVEEDORES_MATERIAL e" +
                    " inner join PROVEEDORES  p  on p.COD_PROVEEDOR = e.COD_PROVEEDOR" +
                    " inner join materiales m on m.COD_MATERIAL = e.COD_MATERIAL" +
                    " left outer join CATEGORIAS_PROVEEDOR cp on cp.COD_CATEGORIA_PROVEEDOR =e.COD_CATEGORIA_PROVEEDOR" +
                    " left outer join ORDENES_COMPRA oc on oc.COD_ORDEN_COMPRA = e.COD_ORDEN_COMPRA" +
                    //" left outer join ingresos_almacen ia on ia.cod_orden_compra = oc.cod_orden_compra and ia.cod_proveedor = e.cod_proveedor " +
                    //" left outer join ingresos_almacen_detalle iade on iade.cod_ingreso_almacen = ia.cod_ingreso_almacen and iade.cod_material = m.cod_material " +
                    " where e.COD_PERIODO_EVALUACION = '"+codPeriodoEvaluacion+"'" +
                    " ORDER BY M.NOMBRE_MATERIAL,P.NOMBRE_PROVEEDOR ";

            System.out.println("sql" + sql);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            int cont = 0;
            String stylo="";
            while (rs.next()) {
                System.out.println("entro "+ cont);
                //System.out.println("ENTRO:"+rs.getString(2));
                cont++;
                String codMaterial = rs.getString("cod_material");
                String nombreMaterial = rs.getString("nombre_material");
                String nombreProveedor = rs.getString("nombre_proveedor");
                String codProveedor = rs.getString("cod_proveedor");
                String nomCategoriaProveedor = rs.getString("nombre_categoria_proveedor");
                int codCategoriaProveedor = rs.getInt("cod_categoria_proveedor");
                double puntaje = redondear(rs.getDouble("puntuacion_total"),2);
                if(nomCategoriaProveedor==null){
                    nomCategoriaProveedor=" NO EVALUADO ";
                    stylo="#123789";
                }
                if(nomCategoriaProveedor.equals("APROBADO")){
                    stylo="GREEN";
                }
                if(nomCategoriaProveedor.equals("APROBADO CON RESERVA")){
                    stylo="ORANGE";
                }
                if(nomCategoriaProveedor.equals("REPROBADO")){
                    stylo="RED";
                }
                String nombre=nomCategoriaProveedor;
                /*String sql_oc="select top 1 i.COD_ORDEN_COMPRA,o.NRO_ORDEN_COMPRA,i.FECHA_INGRESO_ALMACEN
                 from INGRESOS_ALMACEN i , INGRESOS_ALMACEN_DETALLE id,ORDENES_COMPRA o";
                sql_oc +=" where i.COD_INGRESO_ALMACEN=id.COD_INGRESO_ALMACEN  and o.COD_ORDEN_COMPRA=i.COD_ORDEN_COMPRA";
                sql_oc +=" and i.FECHA_INGRESO_ALMACEN BETWEEN '"+fecha_inicio+"' and '"+fecha_final+"' ";
                sql_oc +=" and i.COD_TIPO_INGRESO_ALMACEN=1 and id.COD_MATERIAL='"+codMaterial+"' and i.COD_PROVEEDOR='"+codProveedor+"' and i.COD_PROVEEDOR=o.COD_PROVEEDOR";
                sql_oc +=" order by i.FECHA_INGRESO_ALMACEN desc";
                System.out.println("sql_oc:" + sql_oc);
                Statement st_oc = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_oc = st_oc.executeQuery(sql_oc);*/
                int nro_oc=0;
                String fechaIngreso="";
                SimpleDateFormat f =new SimpleDateFormat("dd/MM/yyyy");
                int codOrdenCompra = 0;
                //while(rs_oc.next()){
                    nro_oc=rs.getInt("nro_orden_compra");
                    //Date fechaIngresoAlmacen=rs.getDate("fecha_ingreso_almacen");
                    codOrdenCompra = rs.getInt("cod_orden_compra");
                //}

%>
                <tr  class="border" title=" " >
                    <td height="30px" align="left" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;">
                        <input type="hidden" name="codMaterial" value="<%=codMaterial%>"/>
                        <input type="hidden" name="codProveedor" value="<%=codProveedor%>"/>
                        <input type="hidden" name="codCategoriaProveedor" value="<%=codCategoriaProveedor%>"/>
                        <input type="hidden" name="puntaje" value="<%=puntaje%>">
                        <input type="hidden" name="codPeriodoEvaluacion" value="<%=codPeriodoEvaluacion%>"/>
                        <input type="hidden" name="fecha" value="<%=fechaIngreso%>"/>
                        <input type="hidden" name="gestion" value="<%=nom_gestion%>"/>
                        <input type="hidden" name="mes" value="<%=nom_mes%>"/>
                        
                        &nbsp;<%=cont%>&nbsp;
                    </td>
                    <td height="30px" align="left" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;">&nbsp;<%=nombreProveedor%></td>
                    <td  align="left" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;">&nbsp;<%=nombreMaterial%></td>
                    <td width="15%"  bgcolor="<%=stylo%>" align="center" style="border-left : solid #ffffff 1px;border-bottom: solid #ffffff 1px;color:#ffffff"><%=nomCategoriaProveedor%></td>
                    <%
                    if(nomCategoriaProveedor.equals(" NO EVALUADO ")){
                        %>
                        <td  align="right" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;">&nbsp; </td>
                        <%
                    }else{
                    %>
                    <td  align="right" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;"><%=redondear(puntaje,2)%>&nbsp; </td>
                        <%
                    }
                    %>
                    <td  align="right" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;"><%=nro_oc%>&nbsp; </td>
                    <td  align="right" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;"><%--=fechaIngresoAlmacen==null?"":sdf.format(fechaIngresoAlmacen) --%>&nbsp; </td>
                    <td  align="center" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;"><a href="navegadorEvaluaProveedoresDetalle.jsf?codProveedor=<%=codProveedor%>&nomProveedor=<%=nombreProveedor%>&codMaterial=<%=codMaterial%>&nomMaterial=<%=nombreMaterial%>&cod_tipo_inc_regional=<%=codPeriodoEvaluacion%>" style="color:blue;" >&nbsp;Evaluar&nbsp;</a></td><%-- target="_BLANK" --%>
                    <td  align="center" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;border-right: solid #333333 1px;"><a href="navegadorEvaluaProveedoresImprimir.jsf?codProveedor=<%=codProveedor%>&nomProveedor=<%=nombreProveedor%>&codMaterial=<%=codMaterial%>&nomMaterial=<%=nombreMaterial%>&puntaje=<%=puntaje%>&cod_tipo_inc_regional=<%=codPeriodoEvaluacion%>&nomGestion=<%=nom_gestion%>&nomMes=<%=nom_mes%>" style="color:blue;" target="_BLANK">&nbsp;Imprimir&nbsp;</a></td>
                </tr>
<%
            }
%>
            </table>
            <%
        } catch (SQLException e) {
            e.printStackTrace();
        }

            %>
            <%--input value="Guardar" class="btn" onclick="guardarEvaluacionProveedor(<%=codPeriodoEvaluacion%>)" /--%>


            <br><br>
            <div align="center">
    </div>
        </form>
    </body>
</html>
