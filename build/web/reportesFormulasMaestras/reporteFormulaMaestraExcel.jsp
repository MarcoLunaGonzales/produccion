<%@ page contentType="application/vnd.ms-excel"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@ page language="java" %>
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

<%! Connection con = null;
String codPresentacion = "";
String nombrePresentacion = "";
String linea_mkt = "";
String agenciaVenta = "";
%>
<%! public String nombrePresentacion1() {
    String nombreproducto = "";
    try {
        con = Util.openConnection(con);
        String sql_aux = "select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='" + codPresentacion + "'";
        System.out.println("PresentacionesProducto:sql:" + sql_aux);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql_aux);
        while (rs.next()) {
            String codigo = rs.getString(1);
            nombreproducto = rs.getString(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreproducto;
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <title>JSP Page</title>
        
        <style>
            .tablaReporte
            {
                font-family:Verdana, Arial, Helvetica, sans-serif;
                font-size:12px;
                border-left:1px solid #bbbbbb;
                border-top:1px solid #bbbbbb;
            }
            .tablaReporte thead tr td
            {
                background-color:rgb(157, 90, 158);
                color:white;
                font-size:12px !important;
                text-align:center;
                font-weight:bold;
            }
            .tablaReporte tr td
            {
                font-size:11px;
                border-right:1px solid #bbbbbb;
                border-bottom:1px solid #bbbbbb;
                padding:0.3em;
            }
            .cambioMateria
            {
                font-size:12px !important;
                background-color:#e1bee2;
                font-weight:bold;
                text-align:center;
            }
            .cambioPresentacion
            {
                padding:0.3em;
                font-size:12px !important;
                background-color:#fcf6c2;
                font-weight:bold;
                text-align:center;
            }
        </style>
    </head>
    <body>
        <form>
            <h4 align="center">Reporte Formulas Maestras Excel</h4>
            <center>
            <table align="center">
                    <%
                    Connection con=null;
                    try 
                    {
                        String codAreaEmpresa=request.getParameter("codAreaEmpresa1");
                        String nombreAreaEmpresa=request.getParameter("nombreAreaEmpresa");
                        String codTipoProduccion=request.getParameter("codTipoProduccionPost");
                        String nombreTipoProduccion=request.getParameter("nombreTipoProduccion");
                        String codProducto=request.getParameter("codProducto");
                        con = Util.openConnection(con);
                %>
                    
                <tr>
                <td align="left" style="padding:0.5em" >
                    <b>Area :</b><%=(nombreAreaEmpresa.equals("")?"TODOS":nombreAreaEmpresa)%><br>
                
                </td>
                </tr>
                <tr>
                    <td><b>Tipo Producción:</b><%=(nombreTipoProduccion.equals("")?"":nombreTipoProduccion)%><br></td>
                </tr>
            </table>
            </center>
            <div class="outputText0" align="center">
                
                
            </div>
            <br>
            <table width="100%" align="center" class="tablaReporte" cellpadding="0" cellspacing="0" >
                
                <thead>
                    <tr class="">
                        <td  >Producto </td>
                        <td  >Area</td>
                        <td >Lote</td>
                        <td >Estado Registro</td>
                        <td >Tipo</td>
                        <td >Descripción/Presentación</td>
                        <td >Material</td>
                        <td >Grupo</td>
                        <td >Capitulo</td>
                        <td >Cantidad</td>
                        <td >Unidad</td>
                    </tr>
                </thead>
                
                <%
                
                
                String consulta="select fm.cod_formula_maestra,fm.cod_compprod,fm.cantidad_lote,fm.estado_sistema,"+
                                        " fm.cod_estado_registro,er.nombre_estado_registro,cp.nombre_prod_semiterminado"+
                                        " ,ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA" +
                                " from FORMULA_MAESTRA fm "+
                                " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=fm.COD_COMPPROD"+
                                " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                                " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=cp.COD_ESTADO_COMPPROD" +
                                " where fm.ESTADO_SISTEMA=1 and fm.ESTADO_SISTEMA=1"+
                                " and cp.COD_ESTADO_COMPPROD=1"+
                                (codTipoProduccion.equals("")?"":" and cp.COD_TIPO_PRODUCCION in ("+codTipoProduccion+")")+
                                (codProducto.equals("")?"":" and cp.COD_COMPPROD in ("+codProducto+")")+
                                (codAreaEmpresa.equals("")?"":" and cp.COD_AREA_EMPRESA in ("+codAreaEmpresa+")")+
                                " order by cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE";
                System.out.println("consulta formulas producto" + consulta);
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato = (DecimalFormat) nf;
                formato.applyPattern("#,##0.00");
                NumberFormat nf1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formatoMil = (DecimalFormat) nf1;
                formatoMil.applyPattern("#,##0");
                Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet resDetalle=null;
                String innerHTML="";
                while (res.next())
                {
                        consulta="select m.NOMBRE_MATERIAL,fm.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material,fm.nro_preparaciones"+
                                    ",g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO"+
                                " from FORMULA_MAESTRA_DETALLE_MP fm"
                                + " inner join materiales m on m.COD_MATERIAL=fm.COD_MATERIAL"
                                + " left outer join grupos g on g.COD_GRUPO=m.COD_GRUPO"
                                + " left outer join capitulos c on c.COD_CAPITULO=g.COD_CAPITULO"+
                                 " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fm.COD_UNIDAD_MEDIDA"+
                                 " where fm.COD_FORMULA_MAESTRA='"+res.getInt("cod_formula_maestra")+"'"+
                                 " order by m.NOMBRE_MATERIAL";
                        System.out.println("consulta mp"+consulta);
                        resDetalle=stDetalle.executeQuery(consulta);
                        while(resDetalle.next())
                        {
                            out.println("<tr>" +
                                    "<td>"+res.getString("nombre_prod_semiterminado")+"</td>" +
                                    "<td>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>" +
                                    "<td>"+res.getInt("cantidad_lote")+"</td>" +
                                    "<td>"+res.getString("nombre_estado_registro")+"</td>" +
                                    "<td>MP</td>" +
                                    "<td>&nbsp;</td>" +
                                    "<td>"+resDetalle.getString("NOMBRE_MATERIAL")+"</td>" +
                                    "<td>"+resDetalle.getString("NOMBRE_GRUPO")+"</td>" +
                                    "<td>"+resDetalle.getString("NOMBRE_CAPITULO")+"</td>" +
                                    "<td style='text-align:right'>"+formato.format(resDetalle.getDouble("CANTIDAD"))+"</td>" +
                                       " <td>"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</td></tr>");
                        }
                        consulta="select m.NOMBRE_MATERIAL,fm.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA"+
                                        ",g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO"+
                                 " from FORMULA_MAESTRA_DETALLE_MR fm"
                                + " inner join MATERIALES m on m.COD_MATERIAL=fm.COD_MATERIAL"
                                + " left outer join grupos g on g.COD_GRUPO=m.COD_GRUPO"
                                + " left outer join capitulos c on c.COD_CAPITULO=g.COD_CAPITULO"+
                                 " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fm.COD_UNIDAD_MEDIDA"+
                                 " where fm.COD_FORMULA_MAESTRA='"+res.getInt("COD_FORMULA_MAESTRA")+"'"+
                                 " order by m.NOMBRE_MATERIAL";
                        System.out.println("consulta mr"+consulta);
                        resDetalle=stDetalle.executeQuery(consulta);
                        while(resDetalle.next())
                        {
                            out.println("<tr>" +
                                        "<td>"+res.getString("nombre_prod_semiterminado")+"</td>" +
                                        "<td>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>" +
                                        "<td>"+res.getInt("cantidad_lote")+"</td>" +
                                        "<td>"+res.getString("nombre_estado_registro")+"</td>" +
                                        "<td>MR</td>" +
                                        "<td>&nbsp;</td>" +
                                        "<td>"+resDetalle.getString("NOMBRE_MATERIAL")+"</td>" +
                                        "<td>"+resDetalle.getString("NOMBRE_GRUPO")+"</td>" +
                                        "<td>"+resDetalle.getString("NOMBRE_CAPITULO")+"</td>" +
                                        "<td style='text-align:right'>"+formato.format(resDetalle.getDouble("CANTIDAD"))+"</td>" +
                                        " <td>"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</td></tr>");
                        }
                        consulta="select pp.COD_PRESENTACION_PRIMARIA,ep.nombre_envaseprim,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                                    " ,m.NOMBRE_MATERIAL,fmdep.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA"
                                    + ",g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO"+
                                 " from PRESENTACIONES_PRIMARIAS pp"
                                + " inner join ENVASES_PRIMARIOS ep on pp.COD_ENVASEPRIM=ep.cod_envaseprim"+
                                 " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                 " inner join FORMULA_MAESTRA_DETALLE_EP fmdep on fmdep.COD_PRESENTACION_PRIMARIA=pp.COD_PRESENTACION_PRIMARIA"+
                                 " and fmdep.COD_FORMULA_MAESTRA='"+res.getInt("COD_FORMULA_MAESTRA")+"'"+
                                 " left outer join materiales m on m.COD_MATERIAL=fmdep.COD_MATERIAL"
                                + " left outer join grupos g on g.COD_GRUPO=m.COD_GRUPO"
                                + " left outer join capitulos c on c.COD_CAPITULO=g.COD_CAPITULO"+
                                 " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmdep.COD_UNIDAD_MEDIDA"+
                                 " where pp.COD_COMPPROD='"+res.getInt("cod_compprod")+"'"+
                                 " order by ep.nombre_envaseprim,tpp.NOMBRE_TIPO_PROGRAMA_PROD,m.NOMBRE_MATERIAL";
                        System.out.println("consulta material ep"+consulta);
                        int codPresentacionPrimaria=0;
                        resDetalle=stDetalle.executeQuery(consulta);
                        while(resDetalle.next())
                        {
                            out.println("<tr>" +
                                        "<td>"+res.getString("nombre_prod_semiterminado")+"</td>" +
                                        "<td>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>" +
                                        "<td>"+res.getInt("cantidad_lote")+"</td>" +
                                        "<td>"+res.getString("nombre_estado_registro")+"</td>" +
                                        "<td>EP</td>" +
                                        "<td class='cambioPresentacion'>"+resDetalle.getString("nombre_envaseprim")+"("+resDetalle.getString("NOMBRE_TIPO_PROGRAMA_PROD")+")</td>"+
                                        "<td>"+resDetalle.getString("NOMBRE_MATERIAL")+"</td>"
                                        + "<td>"+resDetalle.getString("NOMBRE_GRUPO")+"</td>" 
                                        + "<td>"+resDetalle.getString("NOMBRE_CAPITULO")+"</td>" 
                                        + "<td style='text-align:right'>"+formato.format(resDetalle.getDouble("CANTIDAD"))+"</td>" +
                                        " <td>"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</td></tr>");
                        }
                        consulta="select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION,tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,m.NOMBRE_MATERIAL,"+
                                        " m.NOMBRE_MATERIAL,fmdes.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA"
                                        + ",g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO"
                                 + "  from COMPONENTES_PRESPROD cpp"
                                        + " inner join PRESENTACIONES_PRODUCTO pp on cpp.COD_PRESENTACION=pp.cod_presentacion and cpp.COD_ESTADO_REGISTRO=1"+
                                        " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=cpp.COD_TIPO_PROGRAMA_PROD"+
                                        " left outer join FORMULA_MAESTRA_DETALLE_ES fmdes on fmdes.COD_PRESENTACION_PRODUCTO=pp.cod_presentacion"+
                                        " and fmdes.COD_TIPO_PROGRAMA_PROD=cpp.COD_TIPO_PROGRAMA_PROD"+
                                        " and fmdes.COD_FORMULA_MAESTRA='"+res.getInt("COD_FORMULA_MAESTRA")+"'"+
                                        " left outer join MATERIALES m on m.COD_MATERIAL=fmdes.COD_MATERIAL"
                                        + " left outer join grupos g on g.COD_GRUPO=m.COD_GRUPO"
                                        + " left outer join capitulos c on c.COD_CAPITULO=g.COD_CAPITULO"+
                                        " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmdes.COD_UNIDAD_MEDIDA"+
                                 " where cpp.COD_COMPPROD='"+res.getInt("cod_compprod")+"'"+
                                 " order by pp.NOMBRE_PRODUCTO_PRESENTACION,tpp.NOMBRE_TIPO_PROGRAMA_PROD,m.NOMBRE_MATERIAL";
                         System.out.println("consulta es"+consulta);
                         resDetalle=stDetalle.executeQuery(consulta);
                         int codPresentacionSecundaria=0;
                         int codTipoProgramaProd=0;
                         while(resDetalle.next())
                        {
                            if(codPresentacionSecundaria!=resDetalle.getInt("cod_presentacion")||codTipoProgramaProd!=resDetalle.getInt("COD_TIPO_PROGRAMA_PROD"))
                            {
                                out.println("<tr>" +
                                            "<td>"+res.getString("nombre_prod_semiterminado")+"</td>" +
                                            "<td>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>" +
                                            "<td>"+res.getInt("cantidad_lote")+"</td>" +
                                            "<td>"+res.getString("nombre_estado_registro")+"</td>" +
                                            "<td>&nbsp;</td><td>&nbsp;</td><td colspan='5' class='cambioPresentacion'>"+resDetalle.getString("NOMBRE_PRODUCTO_PRESENTACION")+"("+resDetalle.getString("NOMBRE_TIPO_PROGRAMA_PROD")+")</td></tr>");
                                codPresentacionSecundaria=resDetalle.getInt("cod_presentacion");
                                codTipoProgramaProd=resDetalle.getInt("COD_TIPO_PROGRAMA_PROD");
                            }
                            if(resDetalle.getString("NOMBRE_MATERIAL")!=null)
                            {
                                out.println("<tr>" +
                                            "<td>"+res.getString("nombre_prod_semiterminado")+"</td>" +
                                            "<td>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>" +
                                            "<td>"+res.getInt("cantidad_lote")+"</td>" +
                                            "<td>"+res.getString("nombre_estado_registro")+"</td>" +
                                            "<td>ES</td>" +
                                            "<td class='cambioPresentacion'>"+resDetalle.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>"+
                                            "<td>"+resDetalle.getString("NOMBRE_MATERIAL")+"</td>"
                                            + "<td>"+resDetalle.getString("NOMBRE_GRUPO")+"</td>" 
                                            + "<td>"+resDetalle.getString("NOMBRE_CAPITULO")+"</td>" 
                                            + "<td style='text-align:right'>"+formato.format(resDetalle.getDouble("CANTIDAD"))+"</td>" 
                                            
                                            +"<td>"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</td></tr>");
                            }
                            
                        }
                        
                }
                         
           } 
           catch (SQLException e)
           {
                        e.printStackTrace();
           }
                %>
            </table>
            <br>
            
            <br>
            <div align="center">
            </div>
        </form>
    </body>
</html>
