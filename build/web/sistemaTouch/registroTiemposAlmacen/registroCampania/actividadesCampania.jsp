<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@page  import="java.text.SimpleDateFormat" %>
<%@page  import="java.util.Date" %>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<f:view>
    <html>
        <head></head>
        <link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
        <link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
        <link rel="STYLESHEET" type="text/css" href="../../reponse/css/mensajejs.css" />
        <script src="../../reponse/js/scripts.js"></script>
        <script src="../../reponse/js/websql.js"></script>
        <style>
            #tablaActividad
            {
                border-collapse:separate;
                border-spacing:0.7rem;
            }
            
        </style>
        <script type="text/javascript">
            function mostrarSeguimientoActividadCampania(codCampania,codActividad)
               {
                   window.parent.codActividadGeneral=codActividad;
                   window.parent.iniciarProgresoSistema();
                   window.location.href=(window.parent.administradorSistema?"registroAdministrador/navegadorTiemposPersonalAdmin.jsf":"registroPersonal/mostrarSeguimientoPersonalCampania.jsf")+
                                         "?codCampania="+codCampania+
                                         "&codActividad="+codActividad+
                                         "&codPersonal="+window.parent.codPersonalGeneral
                                         "&data="+(new Date()).getTime().toString();
                    

               }
        </script>
    <body>
<%
System.out.println("entreo campania");
        String codCampania=request.getParameter("codCampania");
        String codPersonal=request.getParameter("codPersonal");
        boolean admin=(Integer.valueOf(request.getParameter("admin"))>0);
        int codFormulaMaestra=0;
        try
        {

            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cpp.NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                            " ,cppd.COD_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD,cppd.COD_FORMULA_MAESTRA" +
                            " ,ppp.NOMBRE_PROGRAMA_PROD"+
                            " from CAMPANIA_PROGRAMA_PRODUCCION cpp inner join CAMPANIA_PROGRAMA_PRODUCCION_DETALLE cppd on "+
                            " cpp.COD_CAMPANIA_PROGRAMA_PRODUCCION=cppd.COD_CAMPANIA_PROGRAMA_PRODUCCION"+
                            " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=cppd.COD_COMPPROD"+
                            " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=cppd.COD_TIPO_PROGRAMA_PROD"+
                            " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=cpp.COD_PROGRAMA_PROD"+
                            " where cpp.COD_CAMPANIA_PROGRAMA_PRODUCCION='"+codCampania+"'"+
                            " order by cp.nombre_prod_semiterminado,cppd.COD_LOTE_PRODUCCION";
            System.out.println("consulta buscar lotes "+consulta);
            ResultSet res=st.executeQuery(consulta);
            String lotes="";
            String tiposProgramaProduccion="";
            String innerConsulta="";
            while(res.next())
            {
                lotes+=(lotes.equals("")?"":"<br>")+res.getString("COD_LOTE_PRODUCCION");
                tiposProgramaProduccion+=(tiposProgramaProduccion.equals("")?"":"<br>")+res.getString("COD_LOTE_PRODUCCION");
                innerConsulta+=" inner join ACTIVIDADES_FORMULA_MAESTRA afm"+res.getRow()+" on" +
                               " afm"+res.getRow()+".COD_FORMULA_MAESTRA='"+res.getString("COD_FORMULA_MAESTRA")+"'"+
                               " and afm"+res.getRow()+".COD_AREA_EMPRESA=76 and afm"+res.getRow()+".COD_PRESENTACION=0 " +
                               " and afm"+res.getRow()+".COD_ESTADO_REGISTRO= 1 and afm"+res.getRow()+".COD_ACTIVIDAD=ap.COD_ACTIVIDAD";
            }
            res.last();
            out.println("<div class='row'><div class='large-12 medium-12 small-12 columns'>" +
                        "<table class='tablaLoteAlmacen'  cellpadding='0' cellspacing='0'><thead><tr>"+
                        "<td><span class='textHeaderClass'>Campaña</span></td>" +
                        "<td><span class='textHeaderClass'>Programa<br>Produccion</span></td>" +
                        "<td><span class='textHeaderClass'>Lote</span></td>" +
                        "<td><span class='textHeaderClass'>Tipo<br>Produccion</span></td>" +
                        "</tr></thead><tbody><tr>"+
                        "<td><span class='textHeaderClassBody'>"+res.getString("NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION")+"</span></td>"+
                        "<td><span class='textHeaderClassBody'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</span></td>"+
                        "<td><span class='textHeaderClassBody'>"+lotes+"</span></td>"+
                        "<td><span class='textHeaderClassBody'>"+tiposProgramaProduccion+"</span></td>");
            out.println("</tr><tr><td colspan='4'><center><div  style='width:100%' id='divActividadesProduccion' align='center'>");
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            consulta="select ap.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD,pendiente.pendiente,registrado.registrado"+
                     " from actividades_produccion ap "+innerConsulta+
                     " outer apply("+
                     " select count(*) as pendiente from SEGUIMIENTO_CAMPANIA_PROGRAMA_PRODUCCION_PERSONAL s where s.COD_ACTIVIDAD_PROGRAMA=ap.COD_ACTIVIDAD"+
                     " and s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00'"+
                     " AND s.COD_CAMPANIA_PROGRAMA_PRODUCCION='"+codCampania+"'" +
                     " AND (s.REGISTRO_CERRADO=0 or s.REGISTRO_CERRADO is null)"+
                     (admin?"":" and s.COD_PERSONAL='"+codPersonal+"'")+
                     " ) pendiente" +
                     " outer apply( select count(*) as registrado from SEGUIMIENTO_CAMPANIA_PROGRAMA_PRODUCCION_PERSONAL s where s.COD_ACTIVIDAD_PROGRAMA=ap.COD_ACTIVIDAD"+
                     " and s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00'"+
                     " AND s.COD_CAMPANIA_PROGRAMA_PRODUCCION='"+codCampania+"'"+
                     (admin?"":" and s.COD_PERSONAL='"+codPersonal+"'")+
                     " ) registrado";
            System.out.println("consulta cargar actividades "+consulta);
            res=st.executeQuery(consulta);
            out.println("<table id='tablaActividad' style='border:1px solid #a80077;border-radius:1em;' cellpadding='0' cellspacing='0'><thead><tr><td class='divHeaderClass'><span class='textHeaderClass'>Actividades</span></td></tr></thead><tbody>");
            while(res.next())
            {
                out.println("<tr><td onclick=\"mostrarSeguimientoActividadCampania('"+codCampania+"','"+res.getInt("COD_ACTIVIDAD")+"')\"" +
                            " class='columns "+(res.getInt("pendiente")>0?"divOptionOrange":(res.getInt("registrado")>0?"divOptionGreen":"divOptionGrey"))+"' >"+res.getString("NOMBRE_ACTIVIDAD")+"</td></tr>");
            }
            out.println("</tbody></table></div></center></td></tr></tbody></table></div>");
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
%>
</body>
</html>
</f:view>
