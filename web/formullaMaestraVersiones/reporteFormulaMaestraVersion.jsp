<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import="java.util.Locale" %>
<%@page import="java.text.DecimalFormatSymbols" %>
<%@ page import = "java.text.NumberFormat"%>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
                function editarVersion()
                {
                    var tabla=document.getElementById("form1:dataFormula");
                    var cont=0;
                    for(var i=0;i<tabla.rows.length;i++)
                    {
                        if((tabla.rows[i].cells[0].getElementsByTagName("input").length>0)&&tabla.rows[i].cells[0].getElementsByTagName("input").checked)
                        {
                            cont++;
                        }
                    }
                    if(cont==0)
                    {
                        alert('Debe seleccionar al menos un registro');
                        return false;
                    }
                    if(cont>1)
                    {
                        alert('No puede seleccionar mas de un registro');
                        return false;
                    }
                    return true;
                }
                
    </script>
    <style>
        .eliminado
        {
            background-color:#FFB6C1;
        }
        .modificado
        {
            background-color:#F0E68C;
        }
        .nuevo
        {
            background-color:#90EE90;
        }
        .cabecera
        {
            background-color:#9d5a9e;
            color:white;
        }
        .tablaDetalle
        {
            border-left: solid #bbbbbb 1px;
            border-top: solid #bbbbbb 1px;
        }
        .tablaDetalle thead tr td
        {
            padding:0.4em;
            font-weight:bold;
            background-color:#9d5a9e;
            color:white;
            border-right: solid #cccccc 1px;
            border-bottom: solid #cccccc 1px;
        }
        .tablaDetalle tbody tr td
        {
            padding:0.4em;
            border-right: solid #aaaaaa 1px;
            border-bottom: solid #aaaaaa 1px;
        }
    </style>
        </head>
        <body>
                <div align="center">
                    <table>
                        <tr><td class="headerClassACliente">Datos de la formula</td></tr>
                    <%
                    String codversion=request.getParameter("codversion");
                    String codFormulaMaestra=request.getParameter("codFormulaMaestra");
                    int codVersionAnterior=0;
                    int codVersionProducto=0;
                        try
                        {
                            Connection con=null;
                            con=Util.openConnection(con);
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado,fm.COD_FORMULA_MAESTRA" +
                                            ",versionAnterior.codVersionAnterior,fm.COD_COMPPROD_VERSION"+
                                            " from FORMULA_MAESTRA_VERSION fm inner join componentes_prod  cp on cp.COD_COMPPROD=fm.COD_COMPPROD" +
                                            " outer apply (select top 1 fm1.COD_VERSION as codVersionAnterior from FORMULA_MAESTRA_VERSION fm1 where fm1.COD_COMPPROD=fm.COD_COMPPROD "+
                                            " and fm.COD_FORMULA_MAESTRA=fm1.COD_FORMULA_MAESTRA"+
                                            " and fm1.COD_ESTADO_VERSION_FORMULA_MAESTRA in (2,4) and fm1.COD_VERSION<fm.COD_VERSION"+
                                            " order by fm1.COD_VERSION desc ) versionAnterior"+
                                            " where fm.COD_VERSION='"+codversion+"'"+
                                            " and fm.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                            System.out.println("consulta cabecera "+consulta);
                            ResultSet res=st.executeQuery(consulta);
                            if(res.next())
                            {
                                codVersionProducto=res.getInt("COD_COMPPROD_VERSION");
                                codVersionAnterior=res.getInt("codVersionAnterior");
                                out.println("<tr>" +
                                        "<td><span class='outputText2' style='font-weight:bold'>Producto</span></td>" +
                                        "<td><span class='outputText2' style='font-weight:bold'>::</span></td>" +
                                        "<td><span class='outputText2'>"+res.getString("nombre_prod_semiterminado")+"</span></td>" +
                                        "</tr>");
                            }

                    %>
                    </table>
                    
                    <table style="margin-top:1em">
                        <tr>
                        <td><span class="outputText2" style="font-weight:bold">Eliminado</span></td><td style="width:3em" class="eliminado"></td>
                        <td><span class="outputText2" style="font-weight:bold">Modificado</span></td><td style="width:3em" class="modificado"></td>
                        <td><span class="outputText2" style="font-weight:bold">Nuevo</span></td><td style="width:3em" class="nuevo"></td>
                    </tr></table>
                    <%
                    
                        
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,##0.00");
                        Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                         ResultSet resDetalle=null;
                         int codMaterialCabecera=0;
                         String fracciones="";
                        out.println("<table class='tablaDetalle'  cellpadding='0' cellspacing='0' id='tablaMP' style='margin-top:1em'>"+
                                    " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Datos Formula</span></td>"+
                                    " </tr><tr  align='center'><td colspan='2' ><span class='outputText2' >Cantidad Lote</span></td>"+
                                    "<td colspan='2' ><span class='outputText2'>Estado</span></td>" +
                                    "</tr><tr>" +
                                    "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                    "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                    "</tr></thead><tbody>");

                                consulta="select fm.CANTIDAD_LOTE,fmv.CANTIDAD_LOTE as cantidadLote2,ISNULL(er.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTRO," +
                                                "er1.NOMBRE_ESTADO_REGISTRO as NOMBRE_ESTADO_REGISTRO2,fm.COD_ESTADO_REGISTRO,fmv.COD_ESTADO_REGISTRO as COD_ESTADO_REGISTRO2"+
                                                " from FORMULA_MAESTRA_VERSION fm full outer join FORMULA_MAESTRA_VERSION fmv on "+
                                                " fm.COD_FORMULA_MAESTRA=fmv.COD_FORMULA_MAESTRA and fmv.COD_VERSION='"+codversion+"'" +
                                                " AND FM.COD_VERSION"+(codVersionAnterior>0?"='"+codVersionAnterior+"'":" IS NULL")+
                                                " LEFT OUTER JOIN ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=fm.COD_ESTADO_REGISTRO"+
                                                " LEFT OUTER JOIN ESTADOS_REFERENCIALES er1 on er1.COD_ESTADO_REGISTRO=fmv.COD_ESTADO_REGISTRO"+
                                                " where  ( fm.COD_VERSION='"+codVersionAnterior+"' or fmv.COD_VERSION='"+codversion+"')";
                                System.out.println("consulta diferencias fm "+consulta);
                                res=st.executeQuery(consulta);
                                if(res.next())
                                {
                                    out.println("<tr>" +
                                                    "<td class='"+(res.getString("CANTIDAD_LOTE")==null?"nuevo":(res.getDouble("CANTIDAD_LOTE")!=res.getDouble("cantidadLote2")?"modificado":""))+"'><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD_LOTE"))+"</span></td>" +
                                                    "<td class='"+(res.getString("CANTIDAD_LOTE")==null?"nuevo":(res.getDouble("CANTIDAD_LOTE")!=res.getDouble("cantidadLote2")?"modificado":""))+"'><span class='outputText2'>"+formato.format(res.getDouble("cantidadLote2"))+"</span></td>" +
                                                    "<td class='"+(res.getString("COD_ESTADO_REGISTRO")==null?"nuevo":(res.getDouble("COD_ESTADO_REGISTRO")!=res.getDouble("COD_ESTADO_REGISTRO2")?"modificado":""))+"'><span class='outputText2'>"+res.getString("NOMBRE_ESTADO_REGISTRO")+"</span></td>" +
                                                    "<td class='"+(res.getString("COD_ESTADO_REGISTRO")==null?"nuevo":(res.getDouble("COD_ESTADO_REGISTRO")!=res.getDouble("COD_ESTADO_REGISTRO2")?"modificado":""))+"'><span class='outputText2'>"+res.getString("NOMBRE_ESTADO_REGISTRO2")+"</span></td>" +
                                                    "</tr>");
                                }
                                out.println("</tbody></table>");
                                 out.println("<table class='tablaDetalle'  cellpadding='0' cellspacing='0' id='tablaMP' style='margin-top:1em;'> "+
                                            " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias MP</span></td>"+
                                            " </tr><tr  align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                            "<td colspan='2' ><span class='outputText2'>Cantidad</span></td>" +
                                            "<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td>"+
                                            "<td colspan='2'><span class='outputText2'>Nro Fracciones</span></td>"+
                                            "<td colspan='2' ><span class='outputText2'>Fracciones</span></td></tr><tr>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td> </tr></thead><tbody>");

                                consulta="select m.NOMBRE_MATERIAL,m.COD_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,"+
                                         " fmd.NRO_PREPARACIONES,fmdv.NRO_PREPARACIONES as NRO_PREPARACIONES2,um.NOMBRE_UNIDAD_MEDIDA,fracciones.cantidadIni,fracciones.cantidadFin"+
                                         " from  FORMULA_MAESTRA_DETALLE_MP_VERSION fmd full outer join FORMULA_MAESTRA_DETALLE_MP_VERSION fmdv"+
                                         " on fmd.COD_MATERIAL=fmdv.COD_MATERIAL  and fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmdv.COD_VERSION='"+codversion+"'"+
                                         " and fmd.COD_VERSION"+(codVersionAnterior>0?"='"+codVersionAnterior+"'":" IS NULL")+
                                         " inner join materiales m on (m.COD_MATERIAL=fmd.COD_MATERIAL or m.COD_MATERIAL=fmdv.COD_MATERIAL)"+
                                         " inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA)"+
                                         " outer apply(select fmdf.CANTIDAD as cantidadIni,fmdfv.CANTIDAD as cantidadFin"+
                                         "  from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION fmdf full outer join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION fmdfv on "+
                                         " fmdf.COD_MATERIAL=fmdfv.COD_MATERIAL and fmdf.COD_FORMULA_MAESTRA=fmdfv.COD_FORMULA_MAESTRA  and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=fmdfv.COD_FORMULA_MAESTRA_FRACCIONES"+
                                         " and fmdfv.COD_VERSION=fmdv.COD_VERSION and fmdf.COD_VERSION=fmd.COD_VERSION"+
                                         " where ((fmdf.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmdf.COD_MATERIAL=fmd.COD_MATERIAL  and fmdfv.COD_FORMULA_MAESTRA_FRACCIONES is null and fmdf.COD_VERSION=fmd.COD_VERSION)or"+
                                         " (fmdfv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmdfv.COD_MATERIAL=fmdv.COD_MATERIAL and fmdfv.COD_VERSION=fmdv.COD_VERSION and fmdf.COD_FORMULA_MAESTRA_FRACCIONES is null)OR"+
                                         " (fmdfv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmdfv.COD_MATERIAL=fmdv.COD_MATERIAL and fmdfv.COD_VERSION=fmdv.COD_VERSION and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=fmdfv.COD_FORMULA_MAESTRA_FRACCIONES"+
                                         " and fmdf.COD_MATERIAL=fmdfv.COD_MATERIAL and fmdfv.COD_FORMULA_MAESTRA_FRACCIONES=fmdf.COD_FORMULA_MAESTRA_FRACCIONES))) fracciones"+
                                         " where (fmd.COD_VERSION='"+codVersionAnterior+"' or fmdv.COD_VERSION='"+codversion+"')"+
                                         " order by m.NOMBRE_MATERIAL";
                                System.out.println("consulta version propuesta mp "+consulta);
                                res=st.executeQuery(consulta);
                                codMaterialCabecera=0;
                                fracciones="";
                                int contFracciones=0;
                                while(res.next())
                                {
                                    if(codMaterialCabecera!=res.getInt("COD_MATERIAL"))
                                    {
                                        if(codMaterialCabecera>0)
                                        {
                                            res.previous();
                                            out.println("<tr>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getDouble("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getDouble("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD2"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES2")+"</span></td>" +
                                                    fracciones);
                                            res.next();

                                        }
                                        codMaterialCabecera=res.getInt("COD_MATERIAL");
                                        contFracciones=0;
                                        fracciones="";
                                    }
                                    contFracciones++;
                                    fracciones+=(contFracciones==1?"":"<tr>")+"<td class="+(res.getString("cantidadIni")==null?"nuevo":(res.getString("cantidadFin")==null?"eliminado":(res.getDouble("cantidadIni")!=res.getDouble("cantidadFin")?"modificado":"")))+" ><span class='outputText2'>"+formato.format(res.getDouble("cantidadIni"))+"</span></td>" +
                                                "<td class="+(res.getString("cantidadIni")==null?"nuevo":(res.getString("cantidadFin")==null?"eliminado":(res.getDouble("cantidadIni")!=res.getDouble("cantidadFin")?"modificado":"")))+" ><span class='outputText2'>"+formato.format(res.getDouble("cantidadFin"))+"</span></td></tr>";
                                 }
                                 if(codMaterialCabecera>0)
                                {
                                     res.last();
                                     out.println("<tr>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getDouble("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getDouble("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD2"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES2")+"</span></td>" +
                                                    fracciones);
                                     }
                                     out.println("</tbody></table>");
                                     out.println("<table class='tablaDetalle'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaEP'>"+
                                            " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias EP</span></td>"+
                                            " </tr></thead><tbody>");
                                     consulta="select fep.COD_FORMULA_MAESTRA,ep.nombre_envaseprim,ep.cod_envaseprim,pp.CANTIDAD,"+
                                              " pp.cod_presentacion_primaria,pp.COD_TIPO_PROGRAMA_PROD,tppr.NOMBRE_TIPO_PROGRAMA_PROD,"+
                                              " pp.COD_ESTADO_REGISTRO,erf.NOMBRE_ESTADO_REGISTRO"+
                                              " from FORMULA_MAESTRA_VERSION fep inner join PRESENTACIONES_PRIMARIAS_VERSION pp on PP.COD_COMPPROD =fep.COD_COMPPROD" +
                                              " and PP.COD_VERSION='"+codVersionProducto+"'"+
                                              " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = pp.cod_envaseprim"+
                                              " left outer join tipos_programa_produccion tppr on tppr.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD"+
                                              " left outer join ESTADOS_REFERENCIALES erf on erf.COD_ESTADO_REGISTRO =pp.COD_ESTADO_REGISTRO"+
                                              " where fep.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'" +
                                              " and fep.COD_VERSION = '"+codversion+"' order by ep.nombre_envaseprim";
                                     System.out.println("consulta presentaciones primarias"+consulta);
                                     res=st.executeQuery(consulta);
                                     while(res.next())
                                     {
                                         out.println("<tr><td class='cabecera' colspan='8' align='center'><span class='outputText2'>" +
                                                 "Tipo Prog:"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"<br/>Envase:"+res.getString("nombre_envaseprim")+"<br/>" +
                                                 "Estado:"+res.getString("NOMBRE_ESTADO_REGISTRO")+"<br/>Cantidad:"+res.getInt("CANTIDAD")+"</span></td></tr>" +
                                                 "<tr  class='cabecera' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                                "<td colspan='2' ><span class='outputText2'>Cantidad</span></td>" +
                                                "<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td><tr class='cabecera'>" +
                                                "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>");
                                         consulta="select m.NOMBRE_MATERIAL,fmde.CANTIDAD,fmdev.CANTIDAD as cantidad2,um.NOMBRE_UNIDAD_MEDIDA"+
                                                 " from FORMULA_MAESTRA_DETALLE_EP_VERSION fmde full outer join FORMULA_MAESTRA_DETALLE_EP_VERSION fmdev"+
                                                 "  on fmde.COD_FORMULA_MAESTRA=fmdev.COD_FORMULA_MAESTRA and fmde.COD_MATERIAL=fmdev.COD_MATERIAL and fmdev.COD_VERSION="+codversion+
                                                 " and fmde.COD_VERSION='"+codVersionAnterior+"' and fmde.COD_PRESENTACION_PRIMARIA=fmdev.COD_PRESENTACION_PRIMARIA"+
                                                 " inner join materiales m on (m.COD_MATERIAL=fmde.COD_MATERIAL or m.COD_MATERIAL=fmdev.COD_MATERIAL)"+
                                                 " inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmde.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmdev.COD_UNIDAD_MEDIDA)"+
                                                 " where (fmde.COD_VERSION = '"+codVersionAnterior+"' and fmde.COD_PRESENTACION_PRIMARIA = '"+res.getString("cod_presentacion_primaria")+"' and fmdev.COD_VERSION is null) or"+
                                                 " (fmde.cod_version is null and fmdev.COD_VERSION = '"+codversion+"' and fmdev.COD_PRESENTACION_PRIMARIA = '"+res.getString("cod_presentacion_primaria")+"') OR"+
                                                 " (fmde.COD_VERSION = '"+codVersionAnterior+"' and fmde.COD_PRESENTACION_PRIMARIA = '"+res.getString("cod_presentacion_primaria")+"' and"+
                                                 " fmde.COD_MATERIAL=fmdev.COD_MATERIAL and  fmdev.COD_VERSION = '"+codversion+"') ORDER BY m.NOMBRE_MATERIAL";
                                                 
                                         System.out.println("consulta detalle ep "+consulta);
                                         resDetalle=stDetalle.executeQuery(consulta);
                                         while(resDetalle.next())
                                         {
                                              out.println("<tr>" +
                                                    "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                    "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                                    "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                                    "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                    "</tr>");
                                         }

                                     }
                                     out.println("</tbody></table>");
                                     
                        
                        if(false)
                        {
                             out.println("<table class='tablaDetalle'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaES'>"+
                                    " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias ES</span></td>"+
                                    " </tr></thead><tbody>");
                             consulta="select es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,pp.NOMBRE_PRODUCTO_PRESENTACION,pp.cantidad_presentacion,"+
                                      " pp.cod_presentacion,TPP.NOMBRE_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD"+
                                      " from FORMULA_MAESTRA_VERSION fm inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD"+
                                      " inner join COMPONENTES_PRESPROD c on c.COD_COMPPROD = cp.COD_COMPPROD"+
                                      " inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion =c.COD_PRESENTACION"+
                                      " inner join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC = pp.COD_ENVASESEC"+
                                      " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD =c.COD_TIPO_PROGRAMA_PROD"+
                                      " where fm.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and"+
                                      " fm.COD_VERSION = '"+codversion+"'";
                             System.out.println("consulta eS "+consulta);
                            
                             res=st.executeQuery(consulta);
                             while(res.next())
                             {
                                     out.println("<tr><td class='cabecera' colspan='8' align='center'><span class='outputText2'>" +
                                             "Tipo Prog:"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"<br/>Presentacion:"+res.getString("NOMBRE_ENVASESEC")+"<br/>" +
                                             "Cantidad:"+res.getInt("cantidad_presentacion")+"</span></td></tr>" +
                                             "<tr  class='cabecera' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                            "<td colspan='2' ><span class='outputText2'>Cantidad</span></td>" +
                                            "<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td><tr class='cabecera'>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>");
                                     consulta="select m.NOMBRE_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,um.NOMBRE_UNIDAD_MEDIDA,er.NOMBRE_ESTADO_REGISTRO"+
                                              " from FORMULA_MAESTRA_DETALLE_ES fmd full outer join FORMULA_MAESTRA_DETALLE_ES_VERSION fmdv"+
                                              " on fmdv.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL=fmdv.COD_MATERIAL"+
                                              " and fmdv.COD_PRESENTACION_PRODUCTO=fmd.COD_PRESENTACION_PRODUCTO"+
                                              " and fmdv.COD_TIPO_PROGRAMA_PROD=fmd.COD_TIPO_PROGRAMA_PROD and fmdv.COD_VERSION='"+codversion+"'"+
                                              " inner join materiales m on (m.COD_MATERIAL=fmd.COD_MATERIAL or m.COD_MATERIAL=fmdv.COD_MATERIAL)"+
                                              " inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA)"+
                                              " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO"+
                                              " where ((fmd.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'" +
                                              " and fmd.COD_PRESENTACION_PRODUCTO='"+res.getInt("cod_presentacion")+"' and fmd.COD_TIPO_PROGRAMA_PROD='"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"'" +
                                              " and fmdv.COD_VERSION is null) or"+
                                              " (fmdv.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'" +
                                              " and fmdv.COD_VERSION='"+codversion+"' and fmdv.COD_TIPO_PROGRAMA_PROD='"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"'" +
                                              " and fmdv.COD_PRESENTACION_PRODUCTO='"+res.getInt("cod_presentacion")+"' )"+
                                              " or (fmdv.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'" +
                                              " and fmdv.COD_VERSION='"+codversion+"'" +
                                              " and fmdv.COD_TIPO_PROGRAMA_PROD='"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"' and fmdv.COD_PRESENTACION_PRODUCTO='"+res.getInt("cod_presentacion")+"'"+
                                              " and fmdv.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmd.COD_PRESENTACION_PRODUCTO=fmdv.COD_PRESENTACION_PRODUCTO"+
                                              " and fmdv.COD_TIPO_PROGRAMA_PROD=fmd.COD_TIPO_PROGRAMA_PROD))order by m.NOMBRE_MATERIAL";
                                     System.out.println("consulta detalle es "+consulta);

                                     resDetalle=stDetalle.executeQuery(consulta);
                                     while(resDetalle.next())
                                     {
                                         out.println("<tr>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                "</tr>");
                                     }

                                 }
                                 out.println("</tbody></table>");
                             }
                            if(false)
                           {
                                     out.println("<table class='tablaDetalle'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaMR'>"+
                                            " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias MR</span></td>"+
                                            " </tr></thead><tbody>");
                                     consulta="select tmr.COD_TIPO_MATERIAL_REACTIVO,tmr.NOMBRE_TIPO_MATERIAL_REACTIVO from TIPOS_MATERIAL_REACTIVO tmr where tmr.COD_ESTADO_REGISTRO=1 order by tmr.NOMBRE_TIPO_MATERIAL_REACTIVO";
                                     res=st.executeQuery(consulta);
                                     while(res.next())
                                     {
                                         out.println("<tr><td class='cabecera' colspan='8' align='center'><span class='outputText2'>" +
                                                 "Tipo Material:"+res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO")+"</span></td></tr>" +
                                                 "<tr  class='cabecera' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                                "<td colspan='2' ><span class='outputText2'>Cantidad</span></td>" +
                                                "<td rowspan='2' ><span class='outputText2'>Estado Material</span></td>" +
                                                "<td colspan='2' ><span class='outputText2'>Estado Analisis</span></td>"+
                                                "<td rowspan='2' ><span class='outputText2'>Analisis</span></td>"+
                                                "</tr><tr class='cabecera'>" +
                                                "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                                "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>");
                                          consulta="select m.NOMBRE_MATERIAL,m.COD_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,er.NOMBRE_ESTADO_REGISTRO,"+
                                                   " tamr.nombre_tipo_analisis_material_reactivo,detalle.registrado,detalle.registrado2"+
                                                   " from FORMULA_MAESTRA_DETALLE_MR fmd full outer join FORMULA_MAESTRA_DETALLE_MR_VERSION fmdv on "+
                                                   " fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL=fmdv.COD_MATERIAL"+
                                                   " and fmd.COD_TIPO_MATERIAL=fmdv.COD_TIPO_MATERIAL"+
                                                   " and fmdv.COD_VERSION='"+codversion+"'"+
                                                   " inner join MATERIALES m on (m.COD_MATERIAL=fmd.COD_MATERIAL or fmdv.COD_MATERIAL=m.COD_MATERIAL)"+
                                                   " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO"+
                                                   " outer APPLY TIPOS_ANALISIS_MATERIAL_REACTIVO tamr"+
                                                   " OUTER APPLY (select case when fmc.COD_MATERIAL>0 then 1 else 0 end as registrado, case when fmcv.COD_MATERIAL >0 then 1 else 0 end as registrado2"+
                                                   " from FORMULA_MAESTRA_MR_CLASIFICACION fmc full outer join FORMULA_MAESTRA_MR_CLASIFICACION_VERSION fmcv"+
                                                   " on fmc.COD_FORMULA_MAESTRA=fmcv.COD_FORMULA_MAESTRA and fmc.COD_MATERIAL=fmcv.COD_MATERIAL"+
                                                   " and fmc.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=fmcv.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                                                   " and fmcv.COD_VERSION=fmdv.COD_VERSION"+
                                                   " where ((fmc.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmc.COD_MATERIAL=fmd.COD_MATERIAL ) or"+
                                                   " (fmcv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and  fmcv.COD_MATERIAL=fmdv.COD_MATERIAL and "+
                                                   " fmcv.COD_VERSION=fmdv.COD_VERSION )) and (fmc.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=tamr.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                                                   " or fmcv.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=tamr.COD_TIPO_ANALISIS_MATERIAL_REACTIVO)) as detalle"+
                                                   " where ((fmd.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'" +
                                                   " and fmd.COD_TIPO_MATERIAL='"+res.getInt("COD_TIPO_MATERIAL_REACTIVO")+"')"+
                                                   " or(fmdv.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'" +
                                                   " and fmdv.COD_VERSION='"+codversion+"'" +
                                                   " and fmdv.COD_TIPO_MATERIAL='"+res.getInt("COD_TIPO_MATERIAL_REACTIVO")+"' )) order by m.NOMBRE_MATERIAL,tamr.nombre_tipo_analisis_material_reactivo";
                                               System.out.println("consulta detalle mr "+consulta);
                                               resDetalle=stDetalle.executeQuery(consulta);
                                               codMaterialCabecera=0;
                                               fracciones="";
                                               while(resDetalle.next())
                                               {

                                                   if((resDetalle.getRow()%2)==0)
                                                   {
                                                        out.println("<tr>" +
                                                                    "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                                    "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                                                    "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                                                    "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_ESTADO_REGISTRO")+"</span></td>" +
                                                                    fracciones+
                                                                    "</tr><tr>"+
                                                                    "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado")>0?"checked":"")+"/></td>"+
                                                                   "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado2")>0?"checked":"")+"/></td>"+
                                                                   "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("nombre_tipo_analisis_material_reactivo")+"</span></td></tr>");

                                                   }
                                                   else
                                                   {
                                                       fracciones="<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado")>0?"checked":"")+"/></td>"+
                                                                   "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado2")>0?"checked":"")+"/></td>"+
                                                                   "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("nombre_tipo_analisis_material_reactivo")+"</span></td>";
                                                   }
                                               }
                                     }
                                     out.println("</tbody></table>");
                             }
                        con.close();
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                    %>
                    
                <div align="center" style="margin-top:12px">
                    
                </div>
                </div>
            
        </body>
    </html>
    


