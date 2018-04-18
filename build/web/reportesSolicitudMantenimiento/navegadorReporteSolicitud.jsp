<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.sql.*"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import = "java.util.ArrayList"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 

<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%! Connection con=null;


%>
<%! public String nombreEstadoSolicitud(String codigo){
    
    
    
    String  nombreEstado="";
    
    try{
        con=Util.openConnection(con);
        String sql_aux="select e.NOMBRE_ESTADO_SOLICITUD " ;
        sql_aux+=" from ESTADOS_SOLICITUD_MANTENIMIENTO e" ;
        if(!codigo.equals("0")){
            sql_aux+=" where e.COD_ESTADO_SOLICITUD='"+codigo+"'" ;
        }
        sql_aux+=" order by e.NOMBRE_ESTADO_SOLICITUD";
        System.out.println("ESTADOS_SOLICITUD_MANTENIMIENTO:"+sql_aux);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql_aux);
        while (rs.next()){
            nombreEstado=nombreEstado+","+rs.getString(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreEstado;
}
%>

<%! public String nombreMaquinaria(String codigo){
    
    
    
    String  nombreEstado="Todos";
    
    try{
        con=Util.openConnection(con);
        
        String sql_aux="select m.NOMBRE_MAQUINA,m.CODIGO " ;
        sql_aux+=" from MAQUINARIAS m" ;
        sql_aux+=" where m.COD_MAQUINA='"+codigo+"'" ;
        sql_aux+=" order by m.NOMBRE_MAQUINA";
        System.out.println("MAQUINARIAS:"+sql_aux);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql_aux);
        while (rs.next()){
            nombreEstado=rs.getString(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreEstado;
}
%>
<%! public String nombreAreaEmpresa(String codigo){
    
    
    
    String  nombreEstado="";
    
    try{
        con=Util.openConnection(con);
        
        String sql_aux="select f.COD_AREA_FABRICACION,ae.NOMBRE_AREA_EMPRESA from AREAS_FABRICACION f,AREAS_EMPRESA ae " ;
        sql_aux+=" where ae.COD_AREA_EMPRESA=f.COD_AREA_FABRICACION" ;
        if(!codigo.equals("0")){
            sql_aux+=" and ae.COD_AREA_EMPRESA='"+codigo+"'" ;
        }
        sql_aux+=" order by ae.NOMBRE_AREA_EMPRESA";
        System.out.println("AREAS_FABRICACION:"+sql_aux);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql_aux);
        while (rs.next()){
            nombreEstado=nombreEstado+","+rs.getString(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreEstado;
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../../js/general.js"></script>
    </head>
    <body>
        <h3 align="center">Reporte Solicitud de Mantenimiento </h3>
        <br>
        <form>
            <table align="center" width="90%">
                
                <%
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###");
                
                try{
                    String codAreaEmpresa=request.getParameter("codAreaEmpresa");
                    String codMaquinaria=request.getParameter("codMaquinaria");
                    String codEstadoSolicitud=request.getParameter("codEstado");
                    String nombreEstadoSolicitud=nombreEstadoSolicitud(codEstadoSolicitud);
                    String nombreMaquinaria=nombreMaquinaria(codMaquinaria);
                    String nombreAreaFabricacion=nombreAreaEmpresa(codAreaEmpresa);
                    String codTipoSolicitud = request.getParameter("codTipoSolicitud");


                    String fechaInicio = request.getParameter("fechaInicio").equals("")?"//":request.getParameter("fechaInicio");
                    String fechaFinal = request.getParameter("fechaFinal").equals("")?"//":request.getParameter("fechaFinal");


                    System.out.println("datos  " + codTipoSolicitud + " " + fechaInicio + " " + fechaFinal);
                    String [] fechaInicio1 = fechaInicio.split("/");
                    String [] fechaFinal1 = fechaFinal.split("/");
                    fechaInicio = fechaInicio1[2]+"/"+fechaInicio1[1]+"/"+fechaInicio1[0];
                    fechaFinal = fechaFinal1[2]+"/"+fechaFinal1[1]+"/"+fechaFinal1[0];

                    
                %>
                <tr>
                    <td align="left" class="outputText2" width="25%" >   
                    <td colspan="3" align="center" >
                        <b>  Area de Fabricación : </b><%=nombreAreaFabricacion%>
                    </td>
                    <td align="left" class="outputText2" width="25%" >   
                </tr>
                <tr>
                    <td align="left" width="25%"><img src="../img/cofar.png"></td>
                    <td colspan="3" align="center" >
                        <b>  Estado Solicitud: </b><%=nombreEstadoSolicitud%>
                    </td>
                    <td colspan="3" align="center" >
                        <b>   Maquinaria :</b> <%=nombreMaquinaria%>
                    </td>
                    
                </tr>
            </table>
            <br>
            <br>
            <br>
            <table  align="center" width="90%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
                
                <tr class="tablaFiltroReporte">
                    <th align="center" class="bordeNegroTd" >Nro Solicitud</th>
                    <th align="center" class="bordeNegroTd" >Observaciones</th>
                    <th align="center" class="bordeNegroTd" >Solicitante</th>
                    <th align="center" class="bordeNegroTd" >Ejecutante</th>
                    <th align="center" class="bordeNegroTd" >Fecha Emisión</th>
                    <th align="center" class="bordeNegroTd" >Maquinaria</th>
                    <th align="center" class="bordeNegroTd" >Area Empresa</th>
                    <th align="center" class="bordeNegroTd" >Tipo Solicitud Mantenimiento</th>
                    <th align="center" class="bordeNegroTd" >Estado Solicitud</th>
                    <th align="center" class="bordeNegroTd" >Fecha ejecución</th>
                </tr>
                
                <%
                String sql_4="SELECT S.COD_SOLICITUD_MANTENIMIENTO,S.FECHA_SOLICITUD_MANTENIMIENTO,";
                sql_4+=" (select AE.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA=S.COD_AREA_EMPRESA),";
                sql_4+=" (select TS.NOMBRE_TIPO_SOLICITUD from TIPOS_SOLICITUD_MANTENIMIENTO TS where TS.COD_TIPO_SOLICITUD=S.COD_TIPO_SOLICITUD_MANTENIMIENTO),";
                sql_4+=" (select TOP 1 ES.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES where es.COD_ESTADO_SOLICITUD = s.COD_ESTADO_SOLICITUD_MANTENIMIENTO),"; //select TOP 1 ES.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO=ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC
                sql_4+=" (select M.NOMBRE_MAQUINA from MAQUINARIAS M where M.COD_MAQUINA=S.COD_MAQUINARIA),S.OBS_SOLICITUD_MANTENIMIENTO,G.NOMBRE_GESTION,";
                sql_4+=" ISNULL((select P.AP_PATERNO_PERSONAL+' '+P.AP_MATERNO_PERSONAL+' '+P.NOMBRES_PERSONAL from PERSONAL P where P.COD_PERSONAL=S.COD_PERSONAL),''),";
                sql_4+=" ISNULL((select TOP 1 PE.AP_PATERNO_PERSONAL+' '+PE.AP_MATERNO_PERSONAL+' '+PE.NOMBRES_PERSONAL from PERSONAL PE,APROBACION_SOLICITUDES_MANTENIMIENTO A,ESTADOS_SOLICITUD_MANTENIMIENTO ES where ES.COD_ESTADO_SOLICITUD=A.COD_ESTADO_SOLICITUD_MANTENIMIENTO AND PE.COD_PERSONAL=A.COD_PERSONAL_RESPONSABLE AND A.COD_PERSONAL_RESPONSABLE=PE.COD_PERSONAL AND A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),''),  ";
                sql_4+=" (select TOP 1 A.FECHA_CAMBIO_ESTADOSOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),";
                sql_4+=" (select TOP 1 ES.COD_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC )";
                sql_4+=" FROM SOLICITUDES_MANTENIMIENTO S,GESTIONES G";
                sql_4+=" WHERE  G.COD_GESTION=S.COD_GESTION ";
                if(!codAreaEmpresa.equals("0")){
                    sql_4+=" AND S.COD_AREA_EMPRESA='"+codAreaEmpresa+"'";
                }
                if(!codMaquinaria.equals("0")){
                    sql_4+=" AND S.COD_MAQUINARIA='"+codMaquinaria+"'";
                }
                if(!codTipoSolicitud.equals("0")){
                    sql_4+=" AND S.cod_tipo_solicitud_mantenimiento='"+codTipoSolicitud+"'";
                }
                if(!fechaInicio.equals("") && !fechaFinal.equals("")){
                    sql_4+=" AND S.fecha_solicitud_mantenimiento between '"+fechaInicio+"' and '"+fechaFinal+"'";
                }
                
                sql_4+=" order by S.COD_SOLICITUD_MANTENIMIENTO";
                
                System.out.println("Solicitud Mantenimiento:"+sql_4);
                Statement st_4=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_4=st_4.executeQuery(sql_4);
                while (rs_4.next()){
                    String codSolicitud=rs_4.getString(1);
                    String fechaSolicitud=rs_4.getString(2);
                    String fechaSolicitudVector[]=fechaSolicitud.split(" ");
                    fechaSolicitudVector=fechaSolicitudVector[0].split("-");
                    fechaSolicitud=fechaSolicitudVector[2]+"/"+fechaSolicitudVector[1]+"/"+fechaSolicitudVector[0];
                    String nombreArea=rs_4.getString(3);
                    String nombreTiposolicitud=rs_4.getString(4);
                    String nombreEstadoSol=rs_4.getString(5);
                    String nombreMaquina=rs_4.getString(6);
                    String obsSolicitud=rs_4.getString(7);
                    String nombreGestion=rs_4.getString(8);
                    String nombrePersonalUsuario=rs_4.getString(9);
                    String nombrePersonalEjecutante=rs_4.getString(10);
                    String fechaCambiosolicitud=rs_4.getString(11);
                    String fechaCambiosolicitudVector[]=fechaCambiosolicitud.split(" ");
                    fechaCambiosolicitudVector=fechaCambiosolicitudVector[0].split("-");
                    fechaCambiosolicitud=fechaCambiosolicitudVector[2]+"/"+fechaCambiosolicitudVector[1]+"/"+fechaCambiosolicitudVector[0];
                    String codEstadoSolicitudMante=rs_4.getString(12);
                    if(codEstadoSolicitudMante.equals("4")){
                        fechaCambiosolicitud="";
                    }
                    
                    if(codEstadoSolicitud.equals("0")){
                %>
                
                <tr >
                    <td class="bordeNegroTd" align="center" ><%=codSolicitud%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=obsSolicitud%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombrePersonalUsuario%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombrePersonalEjecutante%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=fechaSolicitud%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombreMaquina%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombreArea%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombreTiposolicitud%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombreEstadoSol%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=fechaCambiosolicitud%>&nbsp;</td>
                </tr>   
                <%
                    }else{
                        if(codEstadoSolicitudMante.equals(codEstadoSolicitud)){
                %>
                
                <tr >
                    <td class="bordeNegroTd" align="center" ><%=codSolicitud%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=obsSolicitud%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombrePersonalUsuario%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombrePersonalEjecutante%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=fechaSolicitud%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombreMaquina%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombreArea%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombreTiposolicitud%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombreEstadoSol%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=fechaCambiosolicitud%>&nbsp;</td>
                </tr>   
                <%
                        }
                    }
                }
                
                
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
            </table>
            
            
            
        </form>
    </body>
</html>