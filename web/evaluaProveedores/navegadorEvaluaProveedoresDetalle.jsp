
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
<%@ page import="com.cofar.web.*" %>


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
            function atras(){
                location="";
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
                            if(f.elements[i].value==15){
                                if(f.elements[i+1].value==1){
                                    valor=1;
                                }
                                if(f.elements[i+1].value==2){
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
                            if(f.elements[i].value==15){
                                if(f.elements[i+1].value==1){
                                    valor=1;
                                }
                                if(f.elements[i+1].value==2){
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

        <form  name="form1" action="guardarEvaluacionProveedores.jsf">
            <%! Connection con = null;
            %>
            <%
        con = Util.openConnection(con);
            %>
            <%
        String sql3 = "";
        String codProveedor = request.getParameter("codProveedor");
        String fecha_inicio = request.getParameter("fecha_inicio");
        String fecha_final = request.getParameter("fecha_final");
        System.out.println("codProveedor:"+codProveedor);
        String codMaterial = request.getParameter("codMaterial");
        String nomProveedor = request.getParameter("nomProveedor");
        String nomMaterial = request.getParameter("nomMaterial");

        String cod_tipo_inc_regional = request.getParameter("cod_tipo_inc_regional");
        System.out.println("cod_tipo_inc_regional:"+cod_tipo_inc_regional);
                       /*ManagedAccesoSistema obj=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");*/
                    ManagedAccesoSistema presupuesto = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
                    //String codPresupuesto = presupuesto.getPresupuestosRRHH().getCodPresupuesto();
                    String codPersonal = presupuesto.getUsuarioModuloBean().getCodUsuarioGlobal();
                    //String codPersonal = "7";
                    //String codPersonal = "303";
                    String codAreaEmpresaPersonal="0";
                    String nroOrdenCompra="0";
                    String fechaEvaluacion="";
                    System.out.println("codPersonal:"+codPersonal);
                          try{
                              con=Util.openConnection(con);
                              String sql=" select COD_AREA_EMPRESA from areas_empresa where cod_area_empresa in (select P.cod_area_empresa from personal P where p.cod_personal="+codPersonal+")";
                              System.out.println("sql:"+sql);
                              Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                              ResultSet rs3 = st3.executeQuery(sql);
                              while(rs3.next()){
                                  codAreaEmpresaPersonal=rs3.getString(1);
				
                              }
		if(!codAreaEmpresaPersonal.equals("30"))codAreaEmpresaPersonal="40";
                         } catch(Exception e) {
                                e.printStackTrace();
                            }
                          try{
                              con=Util.openConnection(con);
                              String sql=" select m.NOMBRE_MATERIAL from  materiales m where m.COD_MATERIAL="+codMaterial+"";
                              System.out.println("sql:"+sql);
                              Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                              ResultSet rs3 = st3.executeQuery(sql);
                              while(rs3.next()){
                                  nomMaterial=rs3.getString(1);
                              }
                         } catch(Exception e) {
                                e.printStackTrace();
                            }
                          try{
                              con=Util.openConnection(con);
                              String sql=" ";
                              if(codAreaEmpresaPersonal.equals("30")){
                                  sql=" SELECT isnull(e.FECHA_COMPRAS,'1900/01/01'),e.NRO_ORDEN_COMPRA FROM EVALUACION_PROVEEDORES_MATERIAL  E WHERE E.COD_PROVEEDOR=" + codProveedor + " AND E.COD_MATERIAL=" + codMaterial + " AND E.COD_PERIODO_EVALUACION=" + cod_tipo_inc_regional + "";
                              }else{
                                  sql=" SELECT isnull(e.FECHA_CONTROL,'1900/01/01'),e.NRO_ORDEN_COMPRA FROM EVALUACION_PROVEEDORES_MATERIAL  E WHERE E.COD_PROVEEDOR=" + codProveedor + " AND E.COD_MATERIAL=" + codMaterial + " AND E.COD_PERIODO_EVALUACION=" + cod_tipo_inc_regional + "";
                              }

                              System.out.println("sql:"+sql);
                              Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                              ResultSet rs3 = st3.executeQuery(sql);
                              while(rs3.next()){
                                  Date f=rs3.getDate(1);
                                  nroOrdenCompra=rs3.getString(2);
                                  SimpleDateFormat f2 =new SimpleDateFormat("dd/MM/yyyy");
                                  fechaEvaluacion=f2.format(f);
                                  System.out.println("---------fechaEvaluacion:"+fechaEvaluacion);
                              }
                         } catch(Exception e) {
                                e.printStackTrace();
                            }
                    //codAreaEmpresaPersonal="38";

                    java.util.Date f =new java.util.Date();
                    SimpleDateFormat f2 =new SimpleDateFormat("dd/MM/yyyy");
                    if(fechaEvaluacion.equals("01/01/1900")){
                        fechaEvaluacion=f2.format(f);
                    }



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
                        <td width="10%" align="right">Evaluación Administrativo/Comercial :</td>
                        
                        <td bgcolor="red" width="15%"> &nbsp;</td>
                  
                        <td width="10%" align="right"> Evaluación Técnica : &nbsp;&nbsp; </td>
                        <td bgcolor="yellow" width="15%"> &nbsp; </td>
             
                        <td width="10%" align="right"> Fecha Evaluación : &nbsp;&nbsp; </td>
                        <td  width="15%">

                            <input type="text"  size="12"  value="<%=fechaEvaluacion%>" name="fecha_inicio" class="inputText">
                            <img id="imagenFecha1" src="../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicio"; click_element_id="imagenFecha1">
                                        </DLCALENDAR> </td>

                        <%
                        if(codAreaEmpresaPersonal.equals("30")){
                            %>
                            <td width="10%" align="right"> Nro. OC :  <input type="text"  size="12"  value="<%=nroOrdenCompra%>" name="nro_oc" class="inputText"></td>
                            <%
                        }
                        else{
                           %>
                            <td width="10%" align="right"> Nro. OC :  <input type="text"  size="12" readonly="true" value="<%=nroOrdenCompra%>" name="nro_oc" class="inputText"></td>
                            <%
                        }
                        %>

            
                    </tr>
                </table>
                            <br>
                                   
            <br>

            <table width="85%" align="center" class="outputText2" style="border : solid #666666 1px;" cellpadding="0" cellspacing="0">
                <tr class="headerClassACliente">
                    <th height="35px" align="center" class=colh style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;">&nbsp;</th>
                    <th align="center" class=colh style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;">CRITERIO</th>
                    <th align="center" class=colh style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;">PARAMETRO</th>
                    <th align="center" class=colh style="border-left : solid #333333 1px;border-bottom: solid #333333 1px;" >PUNTUACION</th>


                </tr>
                <%
        try {
            sql3 = " SELECT E.COD_EVALUACION,E.DESC_EVALUACION,E.COD_AREA_EMPRESA FROM EVALUACION_PROVEEDORES E";
            //sql3 += " WHERE E.cod_area_empresa="+codAreaEmpresaPersonal+" ";
            sql3 += " ORDER BY E.COD_AREA_EMPRESA,E.COD_EVALUACION";

            System.out.println("sql3=" + sql3);
            Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs3 = st3.executeQuery(sql3);
            int c = 0;
            String stylo = "";
            String sw = "false";
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
                System.out.println("codAreaEmpresa:"+codAreaEmpresa);
                System.out.println("codAreaEmpresaPersonal:"+codAreaEmpresaPersonal);
                if(codAreaEmpresaPersonal.equals(codAreaEmpresa)){
                    sw="false";
                }else{
                    sw="true";
                }
                if (codAreaEmpresa.equals("30")) {
                    styloArea = "red";
                } else {
                    styloArea = "yellow";
                }

               System.out.println("sw:"+sw);
                %>
                <tr style="">
                    <%

                    if(codAreaEmpresaPersonal.equals(codAreaEmpresa)){
                        %>
                        <td height="50px" bgcolor="<%=styloArea%>" style="border-left : solid #ffffff 1px;border-bottom: solid #666666 1px;" >&nbsp;<input type="checkbox" name="cod_tipo_inc_regional"  value="<%=codEvaluacion%>"></td>
                        <%
                    sw="false";
                }else{
                    %>
                        <td height="50px" bgcolor="<%=styloArea%>" style="border-left : solid #ffffff 1px;border-bottom: solid #666666 1px;" >&nbsp;<input type="checkbox" name="cod_tipo_inc_regional" disabled="true"  value="<%=codEvaluacion%>"></td>
                        <%
                    sw="true";
                }

                    %>

                    
                    <td bgcolor="<%=stylo%>" style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" >&nbsp;<%=descEvaluacion%></td>


                    <td style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" >
                        <%
                        try {
                            Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql7 = "select e.PUNTAJE,e.DESC_EVALUACION_DETALLE from EVALUACION_PROVEEDORES_DETALLE e where e.COD_EVALUACION=" + codEvaluacion + "";
                            //sql7 += " and e.cod_area_empresa="+codAreaEmpresaPersonal+"";
                            sql7 += " order by e.COD_EVALUACION_DETALLE";
                            System.out.println("sql7:" + sql7);
                            ResultSet rs7 = st7.executeQuery(sql7);
                        %>
                        <TABLE CELLPADDING="0" CELLSPACING="0" width="100%"  class="outputText2">
                            <%
                            String codEvalDetalle = "", puntajeDet = "", descEvalDetalle = "";
                            while (rs7.next()) {
                            %>
                            <tr bgcolor="#123456">
                                <%
                                puntajeDet = rs7.getString(1);
                                descEvalDetalle = rs7.getString(2);
                                %>
                                <td height="17px" bgcolor="<%=stylo%>" width="80%" style="border-bottom: solid #f2f2f2 1px;">&nbsp;<%=descEvalDetalle%>&nbsp;</td>
                                <td bgcolor="<%=stylo%>" width="80%" align="right" style="border-bottom : solid #f2f2f2 1px;"><%=puntajeDet%>&nbsp;&nbsp;&nbsp;</td>
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
                    <td  style="border-left : solid #666666 1px;border-bottom: solid #666666 1px;" align="right" > Puntaje :
                        <%
                        try {
                            double puntuacion=0;
                            String sql_verifica="SELECT e.PUNTUACION FROM EVALUACION_PROVEEDORES_MATERIAL_DETALLE E ";
                            sql_verifica +=" WHERE E.COD_PERIODO_EVALUACION="+cod_tipo_inc_regional+" AND E.COD_MATERIAL="+codMaterial+" AND E.COD_PROVEEDOR="+codProveedor+" AND E.COD_EVALUACION=" + codEvaluacion + "";
                            System.out.println("sql_verifica:" + sql_verifica);
                            Statement st8 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs8 = st8.executeQuery(sql_verifica);
                            while(rs8.next()){
                                puntuacion=rs8.getDouble(1);
                            }


                            Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql7 = "select e.COD_EVALUACION_DETALLE,e.PUNTAJE,e.DESC_EVALUACION_DETALLE from EVALUACION_PROVEEDORES_DETALLE e where e.COD_EVALUACION=" + codEvaluacion + "";
                            sql7 += " order by e.COD_EVALUACION_DETALLE";
                            System.out.println("sql7:" + sql7);
                            ResultSet rs7 = st7.executeQuery(sql7);
                        %>
                                <%

                    if(codAreaEmpresaPersonal.equals(codAreaEmpresa)){
                        %>
                        <select name="" id="" class="outputText3" onchange="calculaIndividual(this.form);"  >

                            <%
                            String codEvalDetalle = "", puntajeDet = "", descEvalDetalle = "";
                            while (rs7.next()) {
                                codEvalDetalle = rs7.getString(1);
                                puntajeDet = rs7.getString(2);
                                descEvalDetalle = rs7.getString(3);
                                if(puntuacion==Double.parseDouble(puntajeDet)){
                                       %>
                            <option value="<%=codEvalDetalle%>" selected> <%=puntajeDet%></option>
                            <%
                                }else{
                                       %>
                            <option value="<%=codEvalDetalle%>"> <%=puntajeDet%></option>
                            <%
                                }
                         
                            }
                            st7.close();
                            rs7.close();
                            %>
                        </select>
                        <%
                    
                }else{
                    %>
                        <select name="" id="" class="outputText3" onchange="calculaIndividual(this.form);"  >

                            <%
                            String codEvalDetalle = "", puntajeDet = "", descEvalDetalle = "";
                            while (rs7.next()) {
                                codEvalDetalle = rs7.getString(1);
                                puntajeDet = rs7.getString(2);
                                descEvalDetalle = rs7.getString(3);
                                if(puntuacion==Double.parseDouble(puntajeDet)){
                                       %>
                            <option value="<%=codEvalDetalle%>" selected disabled="true"> <%=puntajeDet%></option>
                            <%
                                }else{
                                       %>
                            <option value="<%=codEvalDetalle%>" disabled="true"> <%=puntajeDet%></option>
                            <%
                                }
                            }
                            st7.close();
                            rs7.close();
                            %>
                        </select>
                        <%
                   
                }

                    %>
                        
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
                <input type="hidden" name="cod_tipo_inc_regional" value="<%=cod_tipo_inc_regional%>">
            <div align="center">
                Porcentaje Final: <input align="center" type="text" class="outputText2" value="0" name="porcentaje" size="5"> %
                <br>
                <br>

                <input type="button"   class="btn"  size="35" value="Evaluar" name="limpiar" onclick="calcula(this.form);">
                <%--input type="button"   class="btn"  size="35" value="Atrás" name="limpiar"  onclick="atras();"--%>

            </div>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>
