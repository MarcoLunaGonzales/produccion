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
<%! Connection con=null;
%>
<%
con=CofarConnection.getConnectionJsp();    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
           <title>REPORTE DE CUMPLEAÑEROS</title>
        <link rel="STYLESHEET" type="text/css" href="css/ventas.css" />
        <script src="../js/general.js"></script>
        <script> 

        </script>
    </head>
    <body background="img/fondo_c.jpg">
        
        <form name="form1" >
            
            <%  
            
            String sql="";
            String paternoPersonal="";
            String maternoPersonal="";
            String nombrePersonal="";
            String fechaNacimiento="";
            String fechaActualString="";
            String cargoPersonal="";
            String areaEmpresaPersonal="";
            try{
                fechaActualString="";
                Date fechaActual=new Date();
                SimpleDateFormat f=new SimpleDateFormat("yyyy/MM/dd");
                fechaActualString=f.format(fechaActual);
                //fechaActualString="2008/10/05";
                String fechaActualVector[]=fechaActualString.split("/");
                System.out.println("sql="+sql);
                sql=" select p.ap_paterno_personal,p.ap_materno_personal,p.nombres_personal," +
                        " c.descripcion_cargo,ae.nombre_area_empresa,p.fecha_nac_personal";
                sql+=" from personal p,areas_empresa ae, cargos c" +
                        " where cod_estado_persona=1 and " +
                        " MONTH(fecha_nac_personal)='"+fechaActualVector[1]+"' " +
                        " and DAY(fecha_nac_personal)='"+fechaActualVector[2]+"' " +
                        " and p.cod_area_empresa=ae.cod_area_empresa and" +
                        " c.codigo_cargo=p.codigo_cargo";
                System.out.println("sql================="+sql);
                Statement st= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(sql);
            
            
            %>            
            <br>
            
            <div align="center">
                <p><MARQUEE WIDTH=65% class="outputText2" align="center" HEIGHT=10% ><img src="img/lista_c.jpg"></MARQUEE> </p>
                
                
                <br>
                <MARQUEE WIDTH=20% class="outputText2" align="center" HEIGHT=70 direction ="up"><img src="img/cumple2.jpg"></MARQUEE> 
            </div>
            
            <table width="90%" align="center" class="outputText2"  cellpadding="0" cellspacing="0">
                
                <tr class="headerClassACliente">                     
                    
                    <td class="border" align="center">Nombre</td>
                    <td class="border" align="center">Fecha de Nacimiento</td>
                    <td class="border" align="center">Cargo</td>
                    <td class="border" align="center">Area Empresa</td>
                </tr>
                <%
                int sw=0;
                while (rs.next()) {
                    sw=1;
                    paternoPersonal=rs.getString("ap_paterno_personal");
                    maternoPersonal=rs.getString("ap_materno_personal");
                    nombrePersonal=rs.getString("nombres_personal");
                    cargoPersonal=rs.getString("descripcion_cargo");
                    areaEmpresaPersonal=rs.getString("nombre_area_empresa");
                    fechaNacimiento=rs.getString("fecha_nac_personal");
                    String fechaNacimientoVector[]=fechaNacimiento.split(" ");
                    fechaNacimientoVector=fechaNacimientoVector[0].split("-");
                    fechaNacimiento=fechaNacimientoVector[2]+"/"+fechaNacimientoVector[1]+"/"+fechaNacimientoVector[0];
                %>                           
                <tr  class="border" >
                    <td class="border"><%=paternoPersonal%> <%=maternoPersonal%> <%=nombrePersonal%>&nbsp;</td>
                    <td class="border"><%=fechaNacimiento%>&nbsp;</td>
                    <td class="border" ><%=cargoPersonal%>&nbsp;</td>
                    <td class="border"><%=areaEmpresaPersonal%>&nbsp;</td>
                </tr>
                <%
                }
                if(sw==0){
                %>                           
                <tr  class="border" >
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border" ><B>HOY NO HAY CUMPLEAÑEROS&nbsp;</B></td>
                    <td class="border">&nbsp;</td>
                </tr>
                <%
                }
                
            } catch(Exception e) {
            }               
                %> 
                
                <tr></tr>
                <tr></tr>
                <tr></tr>
            </table>
            
            
            <br>
            <div align="center">      
                <%--input type="button"  class="btn" value="Cancelar" name="ac" onClick="retornarAtras(form1)"--%>
            </div>
        </form>
    </body>
</html>
