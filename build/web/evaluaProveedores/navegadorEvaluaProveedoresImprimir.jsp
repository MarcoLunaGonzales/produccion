
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@ page import="java.text.SimpleDateFormat"%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
            function replicar(cod){
                //alert(cod);
                izquierda = (screen.width) ? (screen.width-300)/2 : 100
                arriba = (screen.height) ? (screen.height-400)/2 : 200
                url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';
                //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf';
                opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=350,height=250,left='+izquierda+ ',top=' + arriba + ''
                window.open(url, 'popUp',opciones)
            }

            function CerrarPlanilla(f){
                /*var count=0;
                   var estadoPlanilla=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;*/
                var codigo=0;
                var count=0;
                var elements=document.getElementById('form1');
                //alert(elements.length);
                var rowsElement=elements.length;
                for(var j=0;j<rowsElement-1;j++){
                    //alert(elements[j].value);
                    if(elements[j].checked==true){
                        codigo=elements[j].value;
                        count++;
                    }
                }

                if(count==1){
                    if( confirm("Esta seguro de Cerrar esta Planilla de Aguinaldos?")){
                        if( confirm("Los datos no podran ser modificados")){
                            //alert(codigo);
                            location.href="cerrarPlanillaAguinaldos.jsp?codigo="+codigo;
                            return true
                        }else{ return false
                        }
                    }
                    else{return false
                    }
                } else {
                    if(count==0){
                        alert("No escogio ningun registro");
                        return false;
                    }else
                        if(count>1){
                            alert("Solo puede escoger un registro");
                            return false;
                        }

                }

            }

            function registrar(f){
                f.submit();
            }
            function redondear(numero, decimales) {
                return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
            }
            function calcula(f)
            {
                var i;
                var j=0;
                var valor=0;
                var contAdm=0;;
                var contTec=0;
                datos=new Array();
                for(i=0;i<=f.length-1;i=i+1)
                {
                    if(f.elements[i].type=='checkbox')
                    {	if(f.elements[i].checked==false){
                            //alert("P:"+f.elements[i].value);
                            datos[j++]=f.elements[i].value;
                            datos[j++]=f.elements[i+1].value;
                            if(f.elements[i].value==11){
                                if(f.elements[i+1].value==1){
                                    valor=1;
                                }
                                if(f.elements[i+1].value==2){
                                    valor=50;
                                }
                                if(f.elements[i+1].value==3){
                                    valor=70;
                                }
                            }else{
                                if(f.elements[i+1].value==1){
                                    valor=1;
                                }
                                if(f.elements[i+1].value==2){
                                    valor=2.5;
                                }
                                if(f.elements[i+1].value==3){
                                    valor=5;
                                }
                            }
                            if(f.elements[i].value<10){

                                contAdm=contAdm+valor;
                            }else{
                                //alert("2:"+f.elements[i+1].value);
                                contTec=contTec+valor;
                            }

                        }
                    }
                }
                /* alert("ADM:"+contAdm);
                alert("datos:"+datos);
                alert("TEC:"+contTec);
                alert(((contAdm*1)*30/45));
                alert(((contTec*1)*70/105));*/
                f.codigos.value=datos;
                f.porcentaje.value=redondear(((contAdm*1)*30/45)+((contTec*1)*70/105),2);
                if(confirm("Esta seguro de Evaluar al Proveedor")){
                    f.submit();
                }else{
                    false;
                }

            }
            function calculaIndividual(f)
            {
                var i;
                var j=0;
                var valor=0;
                var contAdm=0;;
                var contTec=0;
                datos=new Array();
                for(i=0;i<=f.length-1;i=i+1)
                {
                    if(f.elements[i].type=='checkbox')
                    {	if(f.elements[i].checked==false){
                            //alert("P:"+f.elements[i].value);
                            datos[j++]=f.elements[i].value;
                            datos[j++]=f.elements[i+1].value;
                            if(f.elements[i].value==11){
                                if(f.elements[i+1].value==1){
                                    valor=1;
                                }
                                if(f.elements[i+1].value==2){
                                    valor=50;
                                }
                                if(f.elements[i+1].value==3){
                                    valor=70;
                                }
                            }else{
                                if(f.elements[i+1].value==1){
                                    valor=1;
                                }
                                if(f.elements[i+1].value==2){
                                    valor=2.5;
                                }
                                if(f.elements[i+1].value==3){
                                    valor=5;
                                }
                            }
                            if(f.elements[i].value<10){

                                contAdm=contAdm+valor;
                            }else{
                                //alert("2:"+f.elements[i+1].value);
                                contTec=contTec+valor;
                            }

                        }
                    }
                }

                f.codigos.value=datos;
                f.porcentaje.value=redondear(((contAdm*1)*30/45)+((contTec*1)*70/105),2);
                //f.submit();
            }
        </script>
    </head>
    <body>

        <form  name="form1" action="guardarEvaluacionProveedores.jsp">
            <%! Connection con = null;
            %>
            <%
        con = Util.openConnection(con);
            %>
            <%
        String sql3 = "";
        String codProveedor = request.getParameter("codProveedor");
        System.out.println("codProveedor:" + codProveedor);
        String codMaterial = request.getParameter("codMaterial");
        String nomProveedor = request.getParameter("nomProveedor");
        String nomMaterial = request.getParameter("nomMaterial");
        String puntaje = request.getParameter("puntaje");
        String nomGestion = request.getParameter("nomGestion");
        String nomMes = request.getParameter("nomMes");
        String cod_tipo_inc_regional = request.getParameter("cod_tipo_inc_regional");
        System.out.println("cod_tipo_inc_regional:"+cod_tipo_inc_regional);
        String nomCategoriaProveedor = request.getParameter("puntaje1");
        Date f_compras;
        Date f_control;
        String fecha_compras="";
        String fecha_control="";
                                 try{
                              con=Util.openConnection(con);
                              String sql=" select m.NOMBRE_MATERIAL from  materiales m where m.COD_MATERIAL="+codMaterial+"";
                              System.out.println("sql:"+sql);
                              Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                              ResultSet rs3 = st3.executeQuery(sql);
                              while(rs3.next()){
                                  nomMaterial=rs3.getString(1);
                              }
                              String sql_v="SELECT isnull(e.FECHA_COMPRAS,'1900/01/01'),isnull(e.FECHA_CONTROL,'1900/01/01') FROM EVALUACION_PROVEEDORES_MATERIAL  E WHERE E.COD_PROVEEDOR="+codProveedor+" AND E.COD_MATERIAL="+codMaterial+" AND E.COD_PERIODO_EVALUACION="+cod_tipo_inc_regional+"";
                              System.out.println("sql:"+sql);
                              st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                              rs3 = st3.executeQuery(sql_v);
                              while(rs3.next()){
                                  f_compras=rs3.getDate(1);
                                  f_control=rs3.getDate(2);
                                  SimpleDateFormat f =new SimpleDateFormat("dd/MM/yyyy");
                                  fecha_compras=f.format(f_compras);
                                  fecha_control=f.format(f_control);
                                  if(fecha_compras.equals("01/01/1900")){
                                      fecha_compras="--/--/----";
                                  }
                                  if(fecha_control.equals("01/01/1900")){
                                      fecha_control="--/--/----";
                                  }
                                 
                              }

                         } catch(Exception e) {
                                e.printStackTrace();
                            }

            %>
            <%!
public double redondear( double numero, int decimales ) {
    return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
}
%>
            <%--h3 align="center">Formulario de Evaluación y Categorización de Proveedores</h3>
            <br>
            <h3 align="center">Proveedor : <%=nomProveedor%></h3>
            <br>
            <h3 align="center">Material : <%=nomMaterial%></h3>
            <br>
            <h3 align="center">Puntaje : <%=puntaje%> </h3>
            <br>
            <%--table width="85%" align="center" class="outputText2"  cellpadding="0" cellspacing="0">
                <tr>
                    <td width="10%" height="30px">&nbsp;</td>
                    <td width="20%" align="right">Evaluación Administrativo/Comercial :&nbsp;</td>

                    <td bgcolor="red" width="15%"> &nbsp;</td>
                    <td width="10%">&nbsp;</td>
                    <td width="20%" align="right"> Evaluación Técnica : &nbsp;&nbsp; </td>
                    <td bgcolor="yellow" width="15%"> &nbsp; </td>
                    <td width="20%">&nbsp;</td>
                </tr>
            </table--%>


            <table  cellpadding="1" cellspacing="0" class="outputText2" width="95%" align="center">
                <tr>
                    <td  width="18%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;border-top: solid #666666 1px;" colspan="2" rowspan="3" align="center">&nbsp;<img src="../img/logo_cofar.png"></td>
                    <th  height="35px" width="34%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;border-top: solid #666666 1px;">&nbsp;ASEGURAMIENTO DE CALIDAD</th>
                    <th  align="left" width="48%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;border-top: solid #666666 1px;border-right: solid #666666 1px;" colspan="3">&nbsp;Página : 1 de 1</th>
                </tr>
                <tr>
                    <th height="35px" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;">&nbsp;ASC-5-002/R04</th>
                    <th align="left" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;border-right: solid #666666 1px;"colspan="3">&nbsp;Vigencia : 13/10/11</th>
                </tr>
                <tr>
                    <th height="35px" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;">&nbsp;FORMULARIO DE EVALUACION A PROVEEDORES<BR> DE MATERIA PRIMA Y MATERIAL DE EMPAQUE</th>
                    <th align="left" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;border-right: solid #666666 1px;"colspan="3">&nbsp;Revision N°:04 <br> Proxim Rev:13/10/15</th>
                </tr>
                <tr>
                    <th height="35px" width="100%" align="left" colspan="6">&nbsp</th>
                </tr>
                <tr>
                    <th height="35px" width="100%" align="left" colspan="6">&nbsp;Evaluacion Correspondiente al Mes de : <%=nomMes%> Gestion : <%=nomGestion%></th>
                </tr>
                <tr>
                    <th height="35px" width="100%" align="left" colspan="6">&nbsp</th>
                </tr>
                <tr bgcolor="#666666">
                    <th height="35px" width="18%" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;border-top: solid #333333 1px;color:#f2f2f2" colspan="2" >&nbsp;NOMBRE DEL PROVEEDOR</th>
                    <th width="34%" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;border-top: solid #333333 1px;color:#f2f2f2">&nbsp;PRODUCTO A EVALUAR</th>
                    <th width="35%" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;border-top: solid #333333 1px;color:#f2f2f2">&nbsp;AREA EVALUADORA</th>
                    <th colspan="2" height="25px" width="35%" style="border-left : solid #333333 1px;border-top: solid #333333 1px;border-bottom: solid #333333 1px;border-right: solid #333333 1px;color:#f2f2f2">&nbsp;FECHA DE EVALUACION</th>
                </tr>
                <tr>
                    <th height="35px" width="18%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" colspan="2" rowspan="2">&nbsp;<%=nomProveedor%></th>
                    <th height="35px" width="34%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" rowspan="2">&nbsp;<%=nomMaterial%></th>
                    <th align="left" height="35px" width="35%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;">&nbsp;COMPRAS Y</th>
                    <th align="right"  colspan="2" height="35px" width="13%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;border-right: solid #666666 1px;">&nbsp;<%=fecha_compras%>&nbsp;</th>
                </tr>
                <tr>
                    <th align="left" height="35px" width="35%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;">&nbsp;ASEGURAMIENTO DE CALIDAD</th>
                    <th align="right"  colspan="2" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;border-right: solid #666666 1px;" >&nbsp;<%=fecha_control%>&nbsp;</th>
                </tr>
                <tr>
                    <th height="35px" width="100%" align="left" colspan="6">&nbsp</th>
                </tr>
                <tr bgcolor="#666666">
                    <th height="35px" width="11%" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;border-top : solid #333333 1px;color:#f2f2f2">&nbsp;PONDERACION % POR 100&nbsp;</th>
                    <th height="25px" width="7%" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;border-top : solid #333333 1px;color:#f2f2f2" >&nbsp;ASPECTO&nbsp;</th>
                    <th height="25px" width="34%" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;border-top : solid #333333 1px;color:#f2f2f2">&nbsp;CRITERIO&nbsp;</th>
                    <th height="25px" width="35%" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;border-top : solid #333333 1px;color:#f2f2f2">&nbsp;PARAMETRO&nbsp;</th>
                    <th height="25px" width="5%" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;border-top : solid #333333 1px;color:#f2f2f2">&nbsp;ESCALA&nbsp;</th>
                    <th height="25px" width="8%" style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;border-top : solid #333333 1px;border-right: solid #333333 1px;color:#f2f2f2">&nbsp;PUNTUACION&nbsp;</th>
                </tr>

            <%--/table>

            <table width="85%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0"--%>
                <%--tr class="headerClassACliente">
                    <th align="center" class=colh style="border : solid #f2f2f2 0px;">&nbsp;</th>
                    <th align="center" class=colh style="border : solid #f2f2f2 0px;">CRITERIO</th>
                    <th align="center" class=colh style="border : solid #f2f2f2 0px;">PARAMETRO</th>
                    <th align="center" class=colh style="border : solid #f2f2f2 0px;" >PUNTUACION</th>


                </tr--%>
                <%
        try {
            sql3 = " SELECT E.COD_EVALUACION,E.DESC_EVALUACION,E.COD_AREA_EMPRESA,EP.PUNTUACION FROM EVALUACION_PROVEEDORES E,EVALUACION_PROVEEDORES_MATERIAL_DETALLE EP";
            sql3 += " WHERE EP.COD_EVALUACION=E.COD_EVALUACION AND EP.COD_PROVEEDOR=" + codProveedor + " AND EP.COD_MATERIAL=" + codMaterial + " and E.COD_AREA_EMPRESA=30 AND EP.COD_PERIODO_EVALUACION="+cod_tipo_inc_regional+"";
            sql3 += " ORDER BY E.COD_EVALUACION";

            System.out.println("sql3=" + sql3);
            Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs3 = st3.executeQuery(sql3);
            int c = 0;
            String stylo = "#ffffff";
            String styloArea = "";
            double total30=0;
            
            while (rs3.next()) {


                String codEvaluacion = rs3.getString("COD_EVALUACION");
                String descEvaluacion = rs3.getString("DESC_EVALUACION");
                String codAreaEmpresa = rs3.getString("COD_AREA_EMPRESA");
                String puntuacion = rs3.getString("PUNTUACION");
                total30 +=Double.parseDouble(puntuacion);
                if (codAreaEmpresa.equals("30")) {
                    styloArea = "red";
                } else {
                    styloArea = "yellow";
                }


                %>
                <tr >
                    <%
                    if(c==0){
                            %>
                         <td bgcolor="" width="11%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" rowspan="9"><img src="../img/30.jpg"></td>
                         <td bgcolor="" width="7%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" rowspan="9"><img src="../img/ADM.jpg"></td>
                        <%

                        c++;
                    }

                    %>

                   
                    
                    <td height="50px" bgcolor="<%=stylo%>" width="50%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" >&nbsp;<%=descEvaluacion%></td>


                    <td style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" width="40%" colspan="2" >
                        <%
                        try {
                            Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql7 = "select e.PUNTAJE,e.DESC_EVALUACION_DETALLE from EVALUACION_PROVEEDORES_DETALLE e where e.COD_EVALUACION=" + codEvaluacion + "";
                            sql7 += " order by e.COD_EVALUACION_DETALLE";
                            System.out.println("sql7:" + sql7);
                            ResultSet rs7 = st7.executeQuery(sql7);
                        %>
                        <TABLE CELLPADDING="0" CELLSPACING="0" width="100%"  class="outputText2">
                            <%
                            String codEvalDetalle = "", puntajeDet = "", descEvalDetalle = "";
                            while (rs7.next()) {
                            %>
                            <tr>
                                <%
                                puntajeDet = rs7.getString(1);
                                descEvalDetalle = rs7.getString(2);
                                
                                %>
                                <td height="18px" bgcolor="<%=stylo%>" style="border-bottom: solid #cccccc 1px;">&nbsp;<%=descEvalDetalle%>&nbsp;</td>
                                <td bgcolor="<%=stylo%>" align="right" style="border-bottom : solid #cccccc 1px;">&nbsp;<%=puntajeDet%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            </tr>
                            <%
                            }
                            st7.close();
                            rs7.close();
                            %>
                        </TABLE>
                        <%

                        } catch (Exception e) {
                        }
                        %>
                    </td>
                    <td  style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;border-right: solid #666666 1px;" align="right" width="8%" > <%=puntuacion%>&nbsp;

                    </td>
                </tr>
                <%
            }
            sql3 = " SELECT E.COD_EVALUACION,E.DESC_EVALUACION,E.COD_AREA_EMPRESA,EP.PUNTUACION FROM EVALUACION_PROVEEDORES E,EVALUACION_PROVEEDORES_MATERIAL_DETALLE EP";
            sql3 += " WHERE EP.COD_EVALUACION=E.COD_EVALUACION AND EP.COD_PROVEEDOR=" + codProveedor + " AND EP.COD_MATERIAL=" + codMaterial + " and E.COD_AREA_EMPRESA=40 AND EP.COD_PERIODO_EVALUACION="+cod_tipo_inc_regional+"";
            sql3 += " ORDER BY E.COD_EVALUACION";

            System.out.println("sql3=" + sql3);
            st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs3 = st3.executeQuery(sql3);
            c = 0;
            stylo = "#ffffff";
            styloArea = "";
            double total70=0;
            while (rs3.next()) {


                String codEvaluacion = rs3.getString("COD_EVALUACION");
                String descEvaluacion = rs3.getString("DESC_EVALUACION");
                String codAreaEmpresa = rs3.getString("COD_AREA_EMPRESA");
                String puntuacion = rs3.getString("PUNTUACION");
                total70 +=Double.parseDouble(puntuacion);
                if (codAreaEmpresa.equals("30")) {
                    styloArea = "red";
                } else {
                    styloArea = "yellow";
                }


                %>
                <tr >
                    <%
                    if(c==0){
                       
                        %>
                         <td bgcolor="" width="11%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" rowspan="8"><img src="../img/70.jpg"></td>
                         <td bgcolor="" width="7%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" rowspan="8"><img src="../img/TECNIO.jpg"></td>
                        <%
                        c++;
                    }

                    %>



                    <td height="50px" bgcolor="<%=stylo%>" width="50%" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" >&nbsp;<%=descEvaluacion%></td>


                    <td style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" width="40%" colspan="2" >
                        <%
                        try {
                            Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql7 = "select e.PUNTAJE,e.DESC_EVALUACION_DETALLE from EVALUACION_PROVEEDORES_DETALLE e where e.COD_EVALUACION=" + codEvaluacion + "";
                            sql7 += " order by e.COD_EVALUACION_DETALLE";
                            System.out.println("sql7:" + sql7);
                            ResultSet rs7 = st7.executeQuery(sql7);
                        %>
                        <TABLE CELLPADDING="0" CELLSPACING="0" width="100%"  class="outputText2">
                            <%
                            String codEvalDetalle = "", puntajeDet = "", descEvalDetalle = "";
                            while (rs7.next()) {
                            %>
                            <tr>
                                <%
                                puntajeDet = rs7.getString(1);
                                descEvalDetalle = rs7.getString(2);
                                
                                %>
                                <td height="18px" bgcolor="<%=stylo%>" style="border-bottom: solid #cccccc 1px;">&nbsp;<%=descEvalDetalle%>&nbsp;</td>
                                <td bgcolor="<%=stylo%>" align="right" style="border-bottom : solid #cccccc 1px;">&nbsp;<%=puntajeDet%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            </tr>
                            <%
                            }
                            st7.close();
                            rs7.close();
                            %>
                        </TABLE>
                        <%

                        } catch (Exception e) {
                        }
                        %>
                    </td>
                    <td  style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;border-right: solid #666666 1px;" align="right" width="8%" > <%=puntuacion%>&nbsp;

                    </td>
                </tr>
                <%
            }
            String estadoProveedor="";
            double punt=redondear(((total30*30)/45)+((total70*70)/105),0);
            if(punt<55){
                estadoProveedor="RECHAZADO";
            }
            if(punt>=56 && punt<=69){
                estadoProveedor="APROBADO CON RESERVA";
            }
            if(punt>69){
                estadoProveedor="APROBADO";
            }

            %>
            <tr>
                    <th height="35px" width="100%" align="left" colspan="6">&nbsp</th>
            </tr>
            <tr bgcolor="">
                    <th height="35px" colspan="3" width="52%" rowspan="5"  >&nbsp;</th>
                    <th height="35px" colspan="3" width="48%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;border-top: solid #666666  1px;border-right: solid #666666  1px;" >&nbsp;RESULTADOS</th>
            </tr>
            <tr bgcolor="">
                    <th align="left" height="25px" colspan="2" width="40%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;"   >&nbsp;PUNTAJE TOTAL</th>
                    <th align="right" height="35px" colspan="1" width="8%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;border-right: solid #666666  1px;" >&nbsp;<%=redondear(total30+total70,2)%>&nbsp;</th>
            </tr>
            <tr bgcolor="">
                    <th align="left" height="25px" colspan="2" width="40%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;"   >&nbsp;PORCENTAJE (Administrativo/Comercial)</th>
                    <th align="right" height="35px" colspan="1" width="8%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;border-right: solid #666666  1px;" >&nbsp;<%=redondear((total30*30)/45,2)%>&nbsp;</th>
            </tr>
            <tr bgcolor="">
                    <th align="left" height="25px" colspan="2" width="40%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;"   >&nbsp;PORCENTAJE (Técnico)</th>
                    <th align="right" height="35px" colspan="1" width="8%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;border-right: solid #666666  1px;" >&nbsp;<%=redondear((total70*70)/105,2)%>&nbsp;</th>
            </tr>
            <tr bgcolor="">
                    <th align="left" height="25px" colspan="2" width="40%"  style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;"  >&nbsp;PORCENTAJE FINAL</th>
                    <th align="right" height="35px" colspan="1" width="8%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;border-right: solid #666666  1px;" >&nbsp;<%=redondear(((total30*30)/45)+((total70*70)/105),2)%>&nbsp;</th>
            </tr>
            <tr bgcolor="">

                    <th height="35px" colspan="3" width="52%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;border-top: solid #666666  1px;border-right: solid #666666  1px;" >&nbsp;DICTAMEN</th>
                    <th height="35px" colspan="3" width="48%" rowspan="5" style="color:red;font-size:large"  >&nbsp;<%=estadoProveedor%></th>
            </tr>
            <tr bgcolor="">
                    <th height="35px"  width="11%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;" >&nbsp;MENOR A 55 %</th>
                    <th height="25px" colspan="2" width="41%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;border-right: solid #666666  1px;"   >&nbsp;RECHAZADO</th>
            </tr>
            <tr bgcolor="">
                    <th height="35px"  width="11%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;" >&nbsp;ENTRE 56 A 69 %</th>
                    <th height="25px" colspan="2" width="41%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;border-right: solid #666666  1px;"   >&nbsp;APROBADO CON RESERVA</th>
            </tr>
            <tr bgcolor="">
                    <th height="35px"  width="11%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;" >&nbsp;MAYOR A 70 %</th>
                    <th height="25px" colspan="2" width="41%" style="border-left: solid #666666  1px;border-bottom: solid #666666  1px;border-right: solid #666666  1px;"   >&nbsp;APROBADO</th>
            </tr>
                    <th height="00px" width="100%" align="left" colspan="6">&nbsp</th>
            </tr>
            </table>





            <%
            int sw_compras=0;
            int sw_control=0;
            int sw_gi=0;
            Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql7 = "select ISNULL(e.FECHA_COMPRAS,'1900/01/01'),ISNULL(e.FECHA_CONTROL,'1900/01/01') from EVALUACION_PROVEEDORES_MATERIAL e where e.COD_PERIODO_EVALUACION="+cod_tipo_inc_regional+" and e.COD_MATERIAL="+codMaterial+"";
            System.out.println("sql7:" + sql7);
            ResultSet rs7 = st7.executeQuery(sql7);
            while(rs7.next()){
                Date fe=rs7.getDate(1);
                Date fe1=rs7.getDate(2);
                SimpleDateFormat ff =new SimpleDateFormat("dd/MM/yyyy");
                String fq=ff.format(fe);
                String fq1=ff.format(fe1);
                if(fq.equals("01/01/1900")){
                   sw_compras=1;
                }
                if(fq1.equals("01/01/1900")){
                    sw_control=1;

                }
            }



            %>
            <table  cellpadding="1" cellspacing="0" class="outputText2" width="95%" align="center">
                <tr>
                    <th height="30px" width="100%" align="left" colspan="6">&nbsp</th>
                </tr>
                <tr>
                    <%--
                    if(sw_compras==0){
                        %>
                        <th height="50px" width="33%" align="center" colspan="1">&nbsp<img src="../img/firmas_dig/7.jpg" height="150px" width="300 px" ></th>
                        <%
                    }else{
                 %>
                        <th height="50px" width="33%" align="center" colspan="1">&nbsp</th>
                        <%
                    }
                    if(sw_control==0){
                        %>
                        <th height="50px" width="33%" align="center" colspan="1">&nbsp<img src="../img/firmas_dig/303.jpg" height="150px" width="300 px" ></th>
                        <%
                    }else{
                 %>
                        <th height="50px" width="33%" align="center" colspan="1">&nbsp</th>
                        <%
                    }
                    --%>
                    <th height="50px" width="33%" align="center" colspan="1">&nbsp<img src="../img/firmas_dig/f_escobar.jpg" height="150px" width="300 px" ></th>
                    <th height="50px" width="33%" align="center" colspan="1">&nbsp<img src="../img/firmas_dig/303.jpg" height="150px" width="300 px" ></th>
                    <th height="50px" width="40%" align="center" colspan="1">&nbsp<img src="../img/firmas_dig/780.jpg" height="150px" width="300 px"></th>
                </tr>
                <tr>
                    <th height="50px" width="33%" align="center" colspan="1">&nbspFirma Compras</th>
                    <th height="50px" width="33%" align="center" colspan="1">&nbspFirma Control de Calidad</th>
                    <th height="50px" width="40%" align="center" colspan="1">&nbspFirma Gerencia Industrial</th>
                </tr>
                <%
        } catch (Exception e) {
            e.printStackTrace();
        }
                %>
            </table>
            <br>

        </form>
    </body>
</html>
