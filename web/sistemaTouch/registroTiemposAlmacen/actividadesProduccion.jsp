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
        <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
        <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
        <link rel="STYLESHEET" type="text/css" href="../reponse/css/mensajejs.css" />
        <script src="../reponse/js/scripts.js"></script>
        <script src="../reponse/js/websql.js"></script>
        <style>
            #tablaActividad
            {
                border-collapse:separate;
                border-spacing:0.6em;
            }
            #tablaActividad tr td
            {
                border:none !important;
            }
        </style>
        <script type="text/javascript">
            function mostrarSeguimientoActividad(codLote,codProgramaProd,codComprod,codTipoProgramaProd,codFormulaMaestra,codActividad)
               {
                   window.parent.codFormulaMaestraGeneral=codFormulaMaestra;
                   window.parent.codActividadGeneral=codActividad;
                    window.parent.iniciarProgresoSistema();
                    window.location.href=(window.parent.administradorSistema?"mostrarSeguimientoActividadesAdministrador.jsf":"mostrarSeguimientoActividades.jsf")+"?codLote="+codLote+
                                         "&codTipoProgramaProd="+codTipoProgramaProd+
                                         "&codComprod="+codComprod+
                                         "&codFormulaMaestra="+codFormulaMaestra+
                                         "&codActividad="+codActividad+
                                         "&data="+(new Date()).getTime().toString()+
                                         "&codProgramaProd="+codProgramaProd+
                                             "&codPersonal="+window.parent.codPersonalGeneral;
                    

               }
        </script>
    <body>
<%
        String codLote=request.getParameter("codLote");
        String codProgramaProd=request.getParameter("codProgramaProd");
        String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
        String codComprod=request.getParameter("codComprod");
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
        String codPersonal=request.getParameter("codPersonal");
        boolean admin=(Integer.valueOf(request.getParameter("admin"))>0);
        int codFormulaMaestra=0;
        try
        {

            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select p.COD_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD,cp.nombre_prod_semiterminado,"+
                            " ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,p.CANT_LOTE_PRODUCCION,p.COD_FORMULA_MAESTRA"+
                            " from PROGRAMA_PRODUCCION p inner join TIPOS_PROGRAMA_PRODUCCION tpp on"+
                            " p.COD_TIPO_PROGRAMA_PROD=tpp.COD_TIPO_PROGRAMA_PROD"+
                            " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=p.COD_COMPPROD"+
                            " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                            " where p.COD_PROGRAMA_PROD='"+codProgramaProd+"' and p.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                            " and p.COD_LOTE_PRODUCCION='"+codLote+"'";
            System.out.println("consulta buscar lotes "+consulta);
            ResultSet res=st.executeQuery(consulta);
            out.println("<div class='row'><div class='large-12 medium-12 small-12 columns'>" +
                        "<table class='tablaLoteAlmacen'  cellpadding='0' cellspacing='0'><thead><tr>"+
                        "<td><span class='textHeaderClass'>Lote</span></td>" +
                        "<td><span class='textHeaderClass'>Programa<br>Produccion</span></td>" +
                        "<td><span class='textHeaderClass'>Producto</span></td>" +
                        "<td><span class='textHeaderClass'>Tipo<br>Produccion</span></td>" +
                        "</tr></thead><tbody><tr>");
            if(res.next())
            {
                codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                out.println("<td><span class='textHeaderClassBody'>"+codLote+"</span></td>"+
                            "<td><span class='textHeaderClassBody'>"+codLote+"</span></td>"+
                            "<td><span class='textHeaderClassBody'>"+res.getString("nombre_prod_semiterminado")+"</span></td>"+
                            "<td><span class='textHeaderClassBody'>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</span></td>");
            }
            out.println("</tr><tr><td colspan='4'><center><div  style='width:100%' id='divActividadesProduccion' align='center'>");
            consulta="select afm.COD_ACTIVIDAD_FORMULA,ap.NOMBRE_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD,seguimiento.registrado," +
                     "pendiente.pendiente"+
                     " from ACTIVIDADES_PRODUCCION ap inner join ACTIVIDADES_FORMULA_MAESTRA afm on"+
                     " ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD and afm.COD_AREA_EMPRESA=76 and afm.COD_ESTADO_REGISTRO=1" +
                     " and afm.COD_PRESENTACION=0"+
                     " outer apply(select count(*) as registrado from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp" +
                     " where spp.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA"+
                     " and spp.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA"+
                     " and spp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                     " and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                     " and spp.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                     " and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                     " and spp.COD_COMPPROD='"+codComprod+"'" +
                     " and spp.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00'" +
                     (admin?"":" and spp.COD_PERSONAL='"+codPersonal+"'")+
                     ") seguimiento" +
                     " outer apply( select count(*) as pendiente"+
                     "  from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA" +
                     " and spp.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA and spp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'" +
                     " and spp.COD_LOTE_PRODUCCION = '"+codLote+"' and spp.COD_PROGRAMA_PROD = '"+codProgramaProd+"'" +
                     " and spp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' and spp.COD_COMPPROD = '"+codComprod+"'" +
                     " and spp.FECHA_INICIO > '"+sdf.format(new Date())+" 00:00'"+
                     (admin?"":" and spp.COD_PERSONAL='"+codPersonal+"'")+
                     " and (spp.REGISTRO_CERRADO=0 or spp.REGISTRO_CERRADO is null)) pendiente"+
                     " where afm.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                     " order by afm.ORDEN_ACTIVIDAD";
            System.out.println("consulta cargar actividades "+consulta);
            res=st.executeQuery(consulta);
            out.println("<table id='tablaActividad' style='border:1px solid #a80077;border-radius:1em;' cellpadding='0' cellspacing='0'><thead><tr><td class='divHeaderClass'><span class='textHeaderClass'>Actividades</span></td></tr></thead><tbody>");
            while(res.next())
            {
                out.println("<tr><td onclick=\"mostrarSeguimientoActividad('"+codLote+"','"+codProgramaProd+"','"+codComprod+"','"+codTipoProgramaProd+"','"+codFormulaMaestra+"','"+res.getInt("COD_ACTIVIDAD_FORMULA")+"')\"" +
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
