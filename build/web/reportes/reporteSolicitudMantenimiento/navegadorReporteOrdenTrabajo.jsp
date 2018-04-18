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
<%! public String nombrePresentacion1(String codPresentacion){
    

 
String  nombreproducto="";

try{
con=Util.openConnection(con);
String sql_aux="select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='"+codPresentacion+"'";
System.out.println("PresentacionesProducto:sql:"+sql_aux);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql_aux);
while (rs.next()){
String codigo=rs.getString(1);
nombreproducto=rs.getString(2);
}
} catch (SQLException e) {
e.printStackTrace();
    }
    return "";
}

public String nombreAlmacen1(String codMaterial,int ordenTrabajo){
String  nombreAlmacen="";

try{
con=Util.openConnection(con);
String sql_aux="select a.NOMBRE_ALMACEN from SALIDAS_ALMACEN s" +
         " inner join SALIDAS_ALMACEN_DETALLE sd on sd.COD_SALIDA_ALMACEN = s.COD_SALIDA_ALMACEN" +
         " inner join almacenes a on a.COD_ALMACEN = s.COD_ALMACEN" +
         " where s.orden_trabajo = '"+ordenTrabajo+"' and s.COD_ALMACEN in(4,14) and sd.COD_MATERIAL = '"+codMaterial+"'";
System.out.println("consulta "+sql_aux);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql_aux);
while (rs.next()){
nombreAlmacen=rs.getString("nombre_almacen");
}
} catch (SQLException e) {
e.printStackTrace();
    }
   return nombreAlmacen;
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>

  <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
  <title>JSP Page</title>
  <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
  <script src="../../js/general.js"></script>
    </head>
    <body>
  <form>
    <table align="center" width="90%">

  <%
  try{
  NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
  DecimalFormat format = (DecimalFormat)nf;
  format.applyPattern("#,##0.00");

    
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");


    String codSolicitudMantenimiento = request.getParameter("codSolicitudMantenimiento")==null?"0":request.getParameter("codSolicitudMantenimiento");


  %>
  <table align="center" width="60%" class='outputText0'>
  <tr>
    <td width="10%">
  <img src="../../img/cofar.png">
    </td>  
  <td align="center" >
    <h3 align="center">Reporte de Orden de Trabajo</h3>
  </td>
  </tr>
    </table>
    </table>
    <%
    String observacionOT = "";
     String consulta = " SELECT S.COD_SOLICITUD_MANTENIMIENTO, S.COD_AREA_EMPRESA, S.COD_GESTION, S.COD_PERSONAL, S.COD_RESPONSABLE," +
     " S.COD_MAQUINARIA, S.COD_TIPO_SOLICITUD_MANTENIMIENTO, S.COD_ESTADO_SOLICITUD_MANTENIMIENTO, S.FECHA_SOLICITUD_MANTENIMIENTO," +
     " S.FECHA_CAMBIO_ESTADOSOLICITUD," +
     " (select AE.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA = S.COD_AREA_EMPRESA ) NOMBRE_AREA_EMPRESA, " +
     " (select TS.NOMBRE_TIPO_SOLICITUD from TIPOS_SOLICITUD_MANTENIMIENTO TS where TS.COD_TIPO_SOLICITUD = S.COD_TIPO_SOLICITUD_MANTENIMIENTO ) NOMBRE_TIPO_SOLICITUD," +
     " (select e.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO e " +
     " where e.COD_ESTADO_SOLICITUD = S.COD_ESTADO_SOLICITUD_MANTENIMIENTO and e.COD_ESTADO_REGISTRO = 1 ) NOMBRE_ESTADO_SOLICITUD," +
     " ( select M.NOMBRE_MAQUINA from MAQUINARIAS M where M.COD_MAQUINA = S.COD_MAQUINARIA ) NOMBRE_MAQUINA," +
     " ( select M.CODIGO from MAQUINARIAS M where M.COD_MAQUINA = S.COD_MAQUINARIA ) CODIGO_MAQUINA ," +
     " S.OBS_SOLICITUD_MANTENIMIENTO, G.NOMBRE_GESTION,( select PE.AP_PATERNO_PERSONAL + ' ' + PE.AP_MATERNO_PERSONAL + ' ' + PE.NOMBRES_PERSONAL " +
     " from PERSONAL pe where pe.COD_PERSONAL = s.COD_PERSONAL ) NOMBRE_PERSONAL, S.COD_FORM_SALIDA, S.NRO_ORDEN_TRABAJO, S.AFECTARA_PRODUCCION," +
     " (select F.NOMBRE_FILIAL from FILIALES F INNER JOIN AREAS_EMPRESA AE ON AE.COD_FILIAL = F.COD_FILIAL WHERE AE.COD_AREA_EMPRESA = S.COD_AREA_EMPRESA) NOMBRE_FILIAL," +
     " ( select pm.NOMBRE_PARTE_MAQUINA from PARTES_MAQUINARIA pm where pm.COD_PARTE_MAQUINA = s.COD_PARTE_MAQUINA ) NOMBRE_PARTE_MAQUINA,S.COD_AREA_INSTALACION," +
     " (SELECT AI.NOMBRE_AREA_INSTALACION FROM AREAS_INSTALACIONES AI WHERE AI.COD_AREA_INSTALACION = S.COD_AREA_INSTALACION) NOMBRE_AREA_INSTALACION, " +
     " ( select m.NOMBRE_MODULO_INSTALACION from AREAS_INSTALACIONES_MODULOS aim " +
     " inner join MODULOS_INSTALACIONES m on m.COD_MODULO_INSTALACION = aim.COD_MODULO_INSTALACION where aim.COD_MODULO_INSTALACION = S.COD_MODULO_INSTALACION AND aim.COD_AREA_INSTALACION=S.COD_AREA_INSTALACION ) NOMBRE_MODULO_INSTALACION,s.descripcion_estado "+
     " FROM SOLICITUDES_MANTENIMIENTO S,   GESTIONES G  " +
     " WHERE G.COD_GESTION = S.COD_GESTION " +
     " AND S.COD_SOLICITUD_MANTENIMIENTO = '"+codSolicitudMantenimiento+"' " +

     " order by S.COD_SOLICITUD_MANTENIMIENTO DESC ";
     System.out.println("consulta"+consulta);
     con = Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet rs=st.executeQuery(consulta);
     int ordenTrabajo = 0;
     if(rs.next()){
         ordenTrabajo = rs.getInt("NRO_ORDEN_TRABAJO");
         observacionOT = rs.getString("descripcion_estado");
    %>

    <table  align="center" width="60%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

      <tr class="tablaFiltroReporte">
        <td  align="center" class="bordeNegroTd" width="20%"><b>&nbsp;Nro OT</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getInt("NRO_ORDEN_TRABAJO")%></td>
        <td  align="center" class="bordeNegroTd" width="20%"><b>solicitud</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getString("COD_SOLICITUD_MANTENIMIENTO")%></td>
      </tr>


      <tr class="tablaFiltroReporte">
        <td  align="center" class="bordeNegroTd" ><b>Planta:</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getString("NOMBRE_FILIAL")%></td>
        <td  align="center" class="bordeNegroTd" ><b>Afecta Produccion</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getInt("AFECTARA_PRODUCCION")==1?"SI":"NO"%></td>
      </tr>

      <tr class="tablaFiltroReporte">
        <td  align="center" class="bordeNegroTd" ><b>Area:</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getString("NOMBRE_AREA_EMPRESA")%></td>
        <td  align="center" class="bordeNegroTd" ><b>Usuario:</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getString("NOMBRE_PERSONAL")%></td>
      </tr>

      <tr class="tablaFiltroReporte">        
        <td  align="center" class="bordeNegroTd" ><b>Emision:</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=sdf1.format(rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO"))%></td>
        <td  align="center" class="bordeNegroTd" ><b>Aprobacion:</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=sdf1.format(rs.getTimestamp("FECHA_CAMBIO_ESTADOSOLICITUD")!=null?rs.getTimestamp("FECHA_CAMBIO_ESTADOSOLICITUD"):new Date())%></td>
      </tr>
      <tr class="tablaFiltroReporte">
       <td  align="center" class="bordeNegroTd" ><b>Area Instalacion:</b></td>
       <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getString("NOMBRE_AREA_INSTALACION")==null?"":rs.getString("NOMBRE_AREA_INSTALACION")%></td>
        <td  align="center" class="bordeNegroTd" ><b>Modulo Instalacion:</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getString("NOMBRE_MODULO_INSTALACION")==null?"":rs.getString("NOMBRE_MODULO_INSTALACION")%></td>
      </tr>
      <tr class="tablaFiltroReporte">
        <td  align="center" class="bordeNegroTd" ><b>Maquinaria:</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getString("NOMBRE_MAQUINA")==null?"":rs.getString("NOMBRE_MAQUINA")%></td>
        <td  align="center" class="bordeNegroTd" ><b>Parte Maquina:</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getString("NOMBRE_PARTE_MAQUINA")==null?"":rs.getString("NOMBRE_PARTE_MAQUINA")%></td>
      </tr>

      <tr class="tablaFiltroReporte">
        <td  align="center" class="bordeNegroTd" ><b>Codigo:</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getString("CODIGO_MAQUINA")==null?"":rs.getString("CODIGO_MAQUINA")%></td>
        <td  align="center" class="bordeNegroTd" ><b>Nivel de Ejecucion:</b></td>
        <td  align="center" class="bordeNegroTd" >&nbsp;<%=rs.getString("NOMBRE_ESTADO_SOLICITUD")%></td>
      </tr>

    </table>
    <%
    }
    %>


    <br>    
   <table align="center" width="60%" class='outputText0'>
  <tr>
    <td width="10%">
    Trabajos a realizar:
    </td>
  
  </tr>
   </table>    
    <br>
    <table  align="center" width="60%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

  <tr class="tablaFiltroReporte">
    <td  align="center" class="bordeNegroTd" width="20%" ><b>Tipo Tarea</b></td>
    <td  align="center" class="bordeNegroTd"><b>Personal Asignado</b></td>
    <td  align="center" class="bordeNegroTd"><b>Proveedor Asignado</b></td>

    <td  align="center" class="bordeNegroTd" width="5%"><b>Descripcion</b></td>
    <td  align="center" class="bordeNegroTd"><b>Fecha Inicial</b></td>

    <td  align="center" class="bordeNegroTd" width="10%"><b>Fecha Final</b></td>
    <td  align="center" class="bordeNegroTd" ><b>Horas Hombre</b></td>
    <td  align="center" class="bordeNegroTd" ><b>Horas Extra</b></td>
  </tr>

  <%

  consulta = " select s.COD_SOLICITUD_MANTENIMIENTO,t.COD_TIPO_TAREA,t.NOMBRE_TIPO_TAREA, s.COD_PERSONAL, " +
          "(select p.NOMBRE_PILA from personal p where p.COD_PERSONAL = s.COD_PERSONAL) NOMBRE_PILA,  " +
          "(select p.AP_PATERNO_PERSONAL from personal p where p.COD_PERSONAL = s.COD_PERSONAL) AP_PATERNO_PERSONAL,  " +
          "(select p.AP_MATERNO_PERSONAL from personal p where p.COD_PERSONAL = s.COD_PERSONAL) AP_MATERNO_PERSONAL, " +
          " s.DESCRIPCION,s.FECHA_INICIAL,s.FECHA_FINAL,s.COD_PROVEEDOR,  " +
          "(select pr.NOMBRE_PROVEEDOR from PROVEEDORES pr where pr.COD_PROVEEDOR = s.COD_PROVEEDOR)  NOMBRE_PROVEEDOR,  " +
          "s.HORAS_HOMBRE,S.HORAS_EXTRA  from SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS s    " +
          "inner join  TIPOS_TAREA t on s.COD_TIPO_TAREA = t.COD_TIPO_TAREA   " +
          "where s.COD_SOLICITUD_MANTENIMIENTO = '"+codSolicitudMantenimiento+"' ";


  System.out.println("consulta"+consulta);
  con = Util.openConnection(con);
  st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  ResultSet rs1=st.executeQuery(consulta);

  while (rs1.next()){
    String nombreTipoTarea = rs1.getString("NOMBRE_TIPO_TAREA");
    String nombrePersonalAsignado= (rs1.getString("NOMBRE_PILA")==null?"":rs1.getString("NOMBRE_PILA"))
                             + " " +(rs1.getString("AP_PATERNO_PERSONAL")==null?"":rs1.getString("AP_PATERNO_PERSONAL"))
                             + " " + (rs1.getString("AP_MATERNO_PERSONAL")==null?"":rs1.getString("AP_MATERNO_PERSONAL"));
    String nombreProveedor = rs1.getString("NOMBRE_PROVEEDOR")==null?"INTERNO":rs1.getString("NOMBRE_PROVEEDOR");
    String descripcion = rs1.getString("DESCRIPCION");
    Date fechaInicial = rs1.getDate("FECHA_INICIAL");
    Date fechaFinal = rs1.getDate("FECHA_FINAL");
    float horasHombre = rs1.getFloat("HORAS_HOMBRE");
    float horasExtra = rs1.getFloat("HORAS_EXTRA");
    

    out.print("<tr>");
    out.print("<td class='bordeNegroTd' align='left'>"+nombreTipoTarea+"</td>");
    out.print("<td class='bordeNegroTd' align='left'>"+nombrePersonalAsignado+"</td>");
    out.print("<td class='bordeNegroTd' align='left'>"+nombreProveedor+"</td>");
    out.print("<td class='bordeNegroTd' align='left'>"+descripcion+"</td>");
    out.print("<td class='bordeNegroTd' align='left'>"+fechaInicial+"</td>");
    out.print("<td class='bordeNegroTd' align='left'>"+fechaFinal+"</td>");
    out.print("<td class='bordeNegroTd' align='left'>"+horasHombre+"</td>");
    out.print("<td class='bordeNegroTd' align='left'>"+horasExtra+"</td>");
    

    
    out.print("</tr>");
    }

 
  %>
   </table>

<br/>
   <table align="center" width="60%" class='outputText0'>
  <tr>
    <td width="10%">
    Materiales:
    </td>
  </tr>
   </table>
    <br>
    <table  align="center" width="60%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
        
  <tr class="tablaFiltroReporte">
    <td  align="center" class="bordeNegroTd" width="20%" ><b>Descripcion</b></td>
    <td  align="center" class="bordeNegroTd"><b>Nombre Material</b></td>
    <td  align="center" class="bordeNegroTd"><b>Cantidad</b></td>
    <td  align="center" class="bordeNegroTd" width="15%"><b>Unidades</b></td>
    <td  align="center" class="bordeNegroTd" width="15%"><b>Almacen</b></td>
  </tr>

  <%

  consulta = " select s.COD_SOLICITUD_MANTENIMIENTO,s.COD_MATERIAL,m.NOMBRE_MATERIAL,u.NOMBRE_UNIDAD_MEDIDA,s.CANTIDAD,s.DESCRIPCION," +
          "( select SUM(sad.CANTIDAD_SALIDA_ALMACEN) from SALIDAS_ALMACEN s1 " +
          " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN = s1.COD_SALIDA_ALMACEN" +
          " where s1.COD_ESTADO_SALIDA_ALMACEN = 1 and s1.orden_trabajo = '"+ordenTrabajo+"' " +
          " and sad.COD_MATERIAL = s.cod_material and s1.COD_ALMACEN = 4 ) salidas_material" +
          " from SOLICITUDES_MANTENIMIENTO_DETALLE_MATERIALES s  " +
          " inner join materiales m on s.COD_MATERIAL = m.COD_MATERIAL  " +
          " inner join UNIDADES_MEDIDA u on m.COD_UNIDAD_MEDIDA = u.COD_UNIDAD_MEDIDA " +
          " where s.COD_SOLICITUD_MANTENIMIENTO = '"+codSolicitudMantenimiento+"' ";


  System.out.println("consulta salidas"+consulta);
  con = Util.openConnection(con);
  st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  ResultSet rs2=st.executeQuery(consulta);
  
  while (rs2.next()){
    String nombreMaterial = rs2.getString("NOMBRE_MATERIAL");
    String nombreUnidadMedida = rs2.getString("NOMBRE_UNIDAD_MEDIDA");
    double cantidad = rs2.getDouble("CANTIDAD");
    String descripcion = rs2.getString("DESCRIPCION");
    int salidasMaterial = rs2.getInt("salidas_material");
    
    out.print("<tr>");
    out.print("<td class='bordeNegroTd' align='left'>"+descripcion+"</td>");
    out.print("<td class='bordeNegroTd' align='left'>"+nombreMaterial+"</td>");
    out.print("<td class='bordeNegroTd' align='left'>"+salidasMaterial+"</td>");//cantidad
    out.print("<td class='bordeNegroTd' align='left'>"+nombreUnidadMedida+"</td>");
    out.print("<td class='bordeNegroTd' align='left'>"+this.nombreAlmacen1(rs2.getString("cod_material"), ordenTrabajo)+"</td>");
    //out.print("<td class='bordeNegroTd' align='left'>"+salidasMaterial+"</td>");


    out.print("</tr>");
    }

 
  %>
   </table>
   
   <br/>
   <table align="center" width="60%" class='outputText0'>
  <tr>
    <td width="10%">
    Informe Trabajo y Comentarios:
    </td>
  </tr>
   </table>
    <br>
    <table  align="center" width="60%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
        
  <tr class="tablaFiltroReporte" >
    <td  align="center" class="bordeNegroTd" width="20%" height="15%"><%=observacionOT%></td>
  </tr>
   </table>
<br/>
    <table align="center" width="60%" class='outputText0'>
  <tr>
    <td width="10%">
    Conformidad:
    </td>
  </tr>
   </table>
    <br>
    <table  align="center" width="60%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

  <tr class="tablaFiltroReporte" >
      <td>
          <table border="0" width="100%">
              <tr>
                  <td>
                      &nbsp;
                  </td>
              </tr>
              <tr>
                  <td>
                      &nbsp;
                  </td>
              </tr>
              <tr>
                  <td align="center">
                    Ejecutante(s)
                  </td>
                  <td align="center">
                    Jefe de Mantenimiento
                  </td>
                  <td align="center">
                    Jefe de Area
                  </td>
                  <td align="center">
                    Gerencia Industrial
                  </td>
              </tr>
          </table>
      </td>    
  </tr>
   </table>
    <%
     }catch(Exception e){
  e.printStackTrace();
  }
    %>
   

  </form>
    </body>
</html>