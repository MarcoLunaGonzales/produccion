package evaluaProveedores;


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
        System.out.println("codProveedor:"+codProveedor);
        String codMaterial = request.getParameter("codMaterial");
        String nomProveedor = request.getParameter("nomProveedor");
        String nomMaterial = request.getParameter("nomMaterial");

            %>
            <h3 align="center">Criterios de Evaluación</h3>
            <br>
            <h3 align="center">Proveedor : <%=nomProveedor%></h3>
            <br>
            <h3 align="center">Material : <%=nomMaterial%></h3>
            <br>
                <table width="85%" align="center" class="outputText2"  cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="10%" height="30px">&nbsp;</td>
                        <td width="20%" align="right">Evaluación Administrativo/Comercial :</td>
                        
                        <td bgcolor="red" width="15%"> &nbsp;</td>
                        <td width="10%">&nbsp;</td>
                        <td width="20%" align="right"> Evaluación Técnica : &nbsp;&nbsp; </td>
                        <td bgcolor="yellow" width="15%"> &nbsp; </td>
                        <td width="20%">&nbsp;</td>
                    </tr>
                </table>
                            <br>
            <br>

            <table width="85%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
                <tr class="headerClassACliente">
                    <th align="center" class=colh style="border : solid #f2f2f2 0px;">&nbsp;</th>
                    <th align="center" class=colh style="border : solid #f2f2f2 0px;">CRITERIO</th>
                    <th align="center" class=colh style="border : solid #f2f2f2 0px;">PARAMETRO</th>
                    <th align="center" class=colh style="border : solid #f2f2f2 0px;" >PUNTUACION</th>


                </tr>
                <%
        try {
            sql3 = " SELECT E.COD_EVALUACION,E.DESC_EVALUACION,E.COD_AREA_EMPRESA FROM EVALUACION_PROVEEDORES E";
            //sql3 += " WHERE E.COD_EVALUACION=D.COD_EVALUACION ";
            sql3 += " ORDER BY E.COD_EVALUACION";

            System.out.println("sql3=" + sql3);
            Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs3 = st3.executeQuery(sql3);
            int c = 0;
            String stylo = "";
            String styloArea = "";
            while (rs3.next()) {
                if (c % 2 == 0) {
                    stylo = "#c2c2c2";
                    c++;
                } else {
                    c++;
                    stylo = "#ffffff";
                }

                String codEvaluacion = rs3.getString("COD_EVALUACION");
                String descEvaluacion = rs3.getString("DESC_EVALUACION");
                String codAreaEmpresa = rs3.getString("COD_AREA_EMPRESA");
                if (codAreaEmpresa.equals("30")) {
                    styloArea = "red";
                } else {
                    styloArea = "yellow";
                }


                %>
                <tr style="border : solid #cccccc 1px;">

                    <td bgcolor="<%=styloArea%>" style="border : solid #f3f3f3 1px;" >&nbsp;<input type="checkbox" name="cod_tipo_inc_regional" value="<%=codEvaluacion%>"></td>
                    <td bgcolor="<%=stylo%>" style="border : solid #f3f3f3 1px;" ><%=descEvaluacion%></td>


                    <td style="border : solid #f3f3f3 1px;" >
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
                                <td bgcolor="<%=stylo%>" width="80%" style="border-bottom: solid #000000 1px;"><%=descEvalDetalle%></td>
                                <td bgcolor="<%=stylo%>" width="80%" align="right" style="border-bottom : solid #000000 1px;"><%=puntajeDet%></td>
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
                    <td  style="border : solid #cccccc 1px;" align="right" > Puntaje :
                        <%
                        try {
                            Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql7 = "select e.COD_EVALUACION_DETALLE,e.PUNTAJE,e.DESC_EVALUACION_DETALLE from EVALUACION_PROVEEDORES_DETALLE e where e.COD_EVALUACION=" + codEvaluacion + "";
                            sql7 += " order by e.COD_EVALUACION_DETALLE";
                            System.out.println("sql7:" + sql7);
                            ResultSet rs7 = st7.executeQuery(sql7);
                        %>
                        <select name="" id="" class="outputText3" onchange="calculaIndividual(this.form);"  >

                            <%
                            String codEvalDetalle = "", puntajeDet = "", descEvalDetalle = "";
                            while (rs7.next()) {
                                codEvalDetalle = rs7.getString(1);
                                puntajeDet = rs7.getString(2);
                                descEvalDetalle = rs7.getString(3);
                            %>
                            <option value="<%=codEvalDetalle%>"> <%=puntajeDet%></option>
                            <%
                            }
                            st7.close();
                            rs7.close();
                            %>
                        </select>
                        <%

                        } catch (Exception e) {
                        }
                        %>
                    </td>
                </tr>
                <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
                %>
            </table>
            <br>
                <input type="hidden" name="codigos">
                <input type="hidden" name="codProveedor" value="<%=codProveedor%>">
                <input type="hidden" name="codMaterial" value="<%=codMaterial%>">
            <div align="center">
                Porcentaje Final: <input align="center" type="text" class="outputText2" value="0" name="porcentaje" size="5"> %
                <br>
                <br>

                <input type="button"   class="btn"  size="35" value="Evaluar" name="limpiar" onclick="calcula(this.form);">
                <input type="button"   class="btn"  size="35" value="Atrás" name="limpiar"  onclick="">

            </div>
        </form>
    </body>
</html>
