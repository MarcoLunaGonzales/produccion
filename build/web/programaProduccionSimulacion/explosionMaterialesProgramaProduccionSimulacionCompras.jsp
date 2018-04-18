<%@page import="javax.faces.context.FacesContext"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
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


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <style>
            .tablaReporte thead tr td
            {
                background-color: rgb(157, 90, 158);
                color: white;
                text-align: center;
            }
            .conexistencia
            {
                background-color:#c6dfc5;
                border:1px solid #87cd83;
            }
            .sinexistencia
            {
                background-color:#eec6bd;
                border:1px solid #f77659;
            }
            .enTransito
            {
                background-color:#fde3ff;
                border:1px solid #f6bbf9;
            }
        </style>
        <script>
            function buscarExplosionMateriales()
            {
                var textoMateriales = document.getElementById("nombreMaterial").value.toLowerCase();
                var textoCapitulos = document.getElementById("nombreCapitulo").value.toLowerCase();
                var textoGrupo = document.getElementById("nombreGrupo").value.toLowerCase();
                var tablaBuscar=document.getElementById("tablaExplosion").getElementsByTagName("tbody")[0];
                var encontrado=false;
                for (var i =0; i < tablaBuscar.rows.length; i++)
                {
                    
                    if(
                         (textoCapitulos.length==0||
                        (tablaBuscar.rows[i].cells[1].innerHTML.toLowerCase().indexOf(textoCapitulos) > -1))&&
                        (textoMateriales.length==0||
                        (tablaBuscar.rows[i].cells[3].innerHTML.toLowerCase().indexOf(textoMateriales) > -1))&&
                        (textoGrupo.length==0||
                        (tablaBuscar.rows[i].cells[2].innerHTML.toLowerCase().indexOf(textoGrupo) > -1))
                    )
                    {
                        for(var j=0;j<tablaBuscar.rows[i].cells[1].rowSpan;j++)
                        {
                            tablaBuscar.rows[i+j].style.display='';
                        }
                    }
                    else
                    {
                        for(var j=0;j<tablaBuscar.rows[i].cells[1].rowSpan;j++)
                        {
                            tablaBuscar.rows[i+j].style.display='none';
                        }
                    }
                    i+=tablaBuscar.rows[i].cells[1].rowSpan-1
                    
                }
            }
        </script>
    </head>
    <body>
        <%
            Connection con=null;
            con=Util.openConnection(con);
            String codigosProducto=request.getParameter("codigos");
            boolean materiaPrima=request.getParameter("codTipoMaterial").contains("1");
            boolean empaquePrimario=request.getParameter("codTipoMaterial").contains("2");
            boolean empaqueSecundario=request.getParameter("codTipoMaterial").contains("3");
            boolean materiaReactivo=request.getParameter("codTipoMaterial").contains("4");
            String[] codigosProductoArray=codigosProducto.split(",");
            boolean conProductosEnProceso = (request.getParameter("conProductosEnProceso").equals("1"));
            String codlote=(request.getParameter("lotes")!=null?request.getParameter("lotes"):"");
            String codProgramaProd = request.getParameter("codProgramaProduccion");
            String codAlmacen=request.getParameter("codAlmacen");
        %>
        <center>
            <span class="outputTextTituloSistema">Explosión  de Materiales Compras</span>
            <table>
                <tr>
                    <td class="outputTextBold">Almacenes</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(request.getParameter("nombreAlmacen"))%></td>
                </tr>
                <tr>
                    <td class="outputTextBold">Con Productos en Proceso</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(request.getParameter("conProductosEnProceso").equals("1")?"SI":"NO")%></td>
                </tr>
                <tr>
                    <td class="outputTextBold">Tipos de Material</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(request.getParameter("nombreTipoMaterial"))%></td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="0" style="padding:4px;margin-top: 1em" >
                <tr>
                    <td class="outputTextBold">Existencia suficiente</td>
                    <td style="width:4em" class="conexistencia">&nbsp;</td>
                    <td class="outputTextBold">Existencia insuficiente</td>
                    <td style="width:4em" class="sinexistencia">&nbsp;</td>
                    <td class="outputTextBold">En transito</td>
                    <td style="width:4em" class="enTransito">&nbsp;</td>
                </tr>
            </table>
        </center>
        <table cellpadding="0" id="tablaExplosion" style="margin-top:1em;" cellspacing="0" class="tablaReporte">
            <thead>
                <tr>
                    <td rowspan="2">Nro</td>
                    <td rowspan="2">Capitulo<br><input id="nombreCapitulo" value="" onkeyup="buscarExplosionMateriales();"/></td>
                    <td rowspan="2">Grupo<br><input id="nombreGrupo" value="" onkeyup="buscarExplosionMateriales();"/></td>
                    <td rowspan="2">Material<br><input id="nombreMaterial" value="" onkeyup="buscarExplosionMateriales();"/></td>
                    <td rowspan="2">Tamaño Lote Produccion</td>
                    <%--td rowspan="2">Stock Min</td--%>
                    <td rowspan="2">Stock Reposicion</td>
                    <%--td rowspan="2">Stock Max</td--%>
                    <td rowspan="2">Unid. Med.</td>
                    <%
                        if(codAlmacen.contains("2"))
                        {
                            out.println("<td rowspan='2'>Aprobados<br>(Almacen Transitorio E.S.)</td>");
                            out.println("<td rowspan='2'>Cuarentena<br>(Almacen Transitorio E.S.)</td>");
                        }
                    %>
                    <td rowspan="2">Aprob</td>
                    <td rowspan="2">Cuar</td>
                    <td rowspan="2">Rech</td>
                    <td rowspan="2">Venc</td>
                    <td rowspan="2">Reanalisis</td>
                    <td rowspan="2">Disponible</td>
                    <td rowspan="2">A Utilizar Prod.</td>
                    <td rowspan="2">Diferencia</td>
                    <td rowspan="2">Diferencia Stock Reposicion</td>
                    <td rowspan="2">Tránsito desde<br>01/01/2015</td>
                    <td rowspan="2">Fecha Entrega desde<br>01/01/2015</td>
                    <td rowspan="2">Proveedor Ultima Compra</td>
                    <td rowspan="2">Ultimo Tipo Compra</td>
                    <td rowspan="2">Ultimo Tipo Transporte</td>
                    <td rowspan="2">Ultima Fecha de Compra</td>
                    <td rowspan="2">Salidas Año Movil</td>
                    <td rowspan="2">Salidas Año Movil Sin Nro Lote</td>
                    <td rowspan="2">Salidas Ultimo Trimestre</td>
                    <td colspan="3">Datos Ultima Salida</td>
                    <td colspan="4">Productos</td>
                    
                </tr>
                <tr>
                    <td>Fecha Ultima Salida</td>
                    <td>Cantidad Ultima Salida</td>
                    <td>Lote Ultima Salida</td>
                    <td>Producto</td>
                    <td>Tipo Material</td>
                    <td>Tipo Programa Producción</td>
                    <td>Cantidad</td>
                </tr>
            </thead>
            <tbody>
        <%
        
        //VERIFICAR FACTIBILDAD DE USO DE LA TABLA
        StringBuilder consulta=new StringBuilder("delete explosion_productos");
                               consulta.append(" where cod_programa_produccion=").append(codProgramaProd);
        System.out.println("consulta eliminar explosion mes "+consulta.toString());
        PreparedStatement pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se elimino la explosion del mes");
        consulta=new StringBuilder("insert into explosion_productos(cod_programa_produccion, cod_compprod)");
                consulta.append(" values(");
                    consulta.append(codProgramaProd).append(",");
                    consulta.append("?");
                consulta.append(")");
        System.out.println("consulta insert programaProducciom explosion "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        for(String codigo:codigosProductoArray)
        {
            pst.setString(1,codigo);
            if(pst.executeUpdate()>0)System.out.println("se registro el producto en la explosion "+codigo);
        }
        
        
        //OBTENIENDO LOS MATERIALES NECESARIOS PARA LA EXPLOSION
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        consulta=new StringBuilder(" SET NOCOUNT ON DECLARE @codigosAlmacen TdatosIntegerRef ");
                                consulta.append(" DECLARE @codigosCapitulo TdatosIntegerRef");
                                consulta.append(" INSERT INTO @codigosAlmacen VALUES (0)");
                                for(String codAlmacenRef:codAlmacen.split(","))
                                    consulta.append(" ,(").append(codAlmacenRef).append(")");
                                consulta.append(" INSERT INTO @codigosCapitulo VALUES (0)");
                                    consulta.append(materiaPrima?",(2)":"");
                                    consulta.append(empaquePrimario?",(3)":"");
                                    consulta.append(empaqueSecundario?",(4),(8)":"");
                                consulta.append(" exec PAA_EXPLOSION_MATERIALES_COMPRAS ?,@codigosAlmacen,@codigosCapitulo,"+(materiaReactivo?1:0));
                                consulta.append(" SET NOCOUNT OFF");
        System.out.println("consulta extraer materiales necesario "+consulta.toString());
        PreparedStatement pstCab=con.prepareStatement(consulta.toString());
        pstCab.setString(1,sdf.format(new Date()));
        ResultSet res=pstCab.executeQuery();
        
        //preparestatement de productos que utilizan dicho material
        consulta=new StringBuilder("select sum(ppd.CANTIDAD) as cantidadLote,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                         consulta.append(" ,tm.NOMBRE_TIPO_MATERIAL");
                 consulta.append(" from PROGRAMA_PRODUCCION pp ");
                        consulta.append("  inner join COMPONENTES_PROD cp on pp.COD_COMPPROD=cp.COD_COMPPROD");
                         consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                         consulta.append(" inner join PROGRAMA_PRODUCCION_DETALLE ppd on ppd.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                                 consulta.append(" and ppd.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION and pp.COD_COMPPROD=ppd.COD_COMPPROD");
                                 consulta.append(" and ppd.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                         consulta.append(" inner join TIPOS_MATERIAL tm on tm.COD_TIPO_MATERIAL=ppd.COD_TIPO_MATERIAL");
                 consulta.append(" where  ppd.cod_material=?");
                 consulta.append(" and ppd.COD_MATERIAL in ");
                        consulta.append("(");
                              consulta.append(" select f.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP f where f.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                              consulta.append(" union select f1.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ep f1 where f1.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                              consulta.append(" union select f2.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES f2 where f2.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                              consulta.append(" union select f3.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_mr f3 where f3.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                        consulta.append(")");
                 consulta.append(" and ((");
                         consulta.append(" ppd.COD_PROGRAMA_PROD in (").append(codProgramaProd).append(")");
                         consulta.append(" and pp.COD_ESTADO_PROGRAMA=4");
                         consulta.append(" and pp.COD_COMPPROD in (").append(codigosProducto).append(")");
                         consulta.append(" and pp.COD_LOTE_PRODUCCION + '$' + cast (pp.COD_TIPO_PROGRAMA_PROD as varchar) in (").append(codlote).append(")");
                 consulta.append(" )");
                 if(conProductosEnProceso)
                    consulta.append(" or pp.COD_ESTADO_PROGRAMA=7");
                 consulta.append(" )group by cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,tm.NOMBRE_TIPO_MATERIAL");
                 consulta.append(" order by cp.nombre_prod_semiterminado");
        System.out.println("consulta preparedstatement de productos que utilizan un material "+consulta.toString());
        PreparedStatement pstLotes=con.prepareStatement(consulta.toString());
        ResultSet resLotes;
        StringBuilder innerHTMLLotes;
        Double cantidadUtilizarMaterial=0d;
        int cantidadRowSpan=0;
        //exitencias y stocks por material
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat formato = (DecimalFormat) nf;
        formato.applyPattern("#,##0.00");
        sdf=new SimpleDateFormat("dd/MM/yyyy");
        while(res.next())
        {
            //datos de lotes que utilizan un material
                pstLotes.setInt(1,res.getInt("cod_material"));
                resLotes=pstLotes.executeQuery();
                innerHTMLLotes=new StringBuilder("");
                cantidadUtilizarMaterial=0d;
                cantidadRowSpan=1;
                while(resLotes.next())
                {
                    if(resLotes.getRow()>1)
                        innerHTMLLotes.append("<tr>");
                            innerHTMLLotes.append("<td>").append(resLotes.getString("nombre_prod_semiterminado")).append("</td>");
                            innerHTMLLotes.append("<td>").append(resLotes.getString("NOMBRE_TIPO_MATERIAL")).append("</td>");
                            innerHTMLLotes.append("<td>").append(resLotes.getString("NOMBRE_TIPO_PROGRAMA_PROD")).append("</td>");
                            innerHTMLLotes.append("<td align='right'>").append(formato.format(resLotes.getDouble("cantidadLote"))).append("</td>");
                    innerHTMLLotes.append("</tr>");
                    cantidadUtilizarMaterial+=resLotes.getDouble("cantidadLote");
                    cantidadRowSpan++;
                }
                if(innerHTMLLotes.length()>0)
                    innerHTMLLotes.append("<tr>");
                
                    innerHTMLLotes.append("<td colspan=3 align='right' class='outputTextBold'>Total::</td>");
                    innerHTMLLotes.append("<td align='right' class='outputTextBold' >").append(formato.format(cantidadUtilizarMaterial)).append("</td>");
                innerHTMLLotes.append("</tr>");
            //datos calculados
            Double cantidadDisponible=res.getDouble("cantidadAprobados")+res.getDouble("cantidadCuarentena")+res.getDouble("cantidadReanalisis")+res.getDouble("cantidadAprobadosTransitorio")+res.getDouble("cantidadCuarentenaTransitorio");
            //imprimiendo datos obtenidos
            out.println("<tr>");
                out.println("<td rowspan='"+cantidadRowSpan+"'>"+res.getRow()+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"'>"+res.getString("NOMBRE_CAPITULO")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"'>"+res.getString("NOMBRE_GRUPO")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"'>"+res.getString("NOMBRE_MATERIAL")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+(Math.max(Math.max(res.getDouble("cantidadMp"),res.getDouble("cantidadEp")),Math.max(res.getDouble("cantidadEs"),res.getDouble("cantidadMr"))))+"\n ("+(res.getInt("cdMp")+res.getInt("cdMr")+res.getInt("cdEp")+res.getInt("cdEs"))+")</td>");
                //out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("STOCK_MINIMO_MATERIAL"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("STOCK_SEGURIDAD"))+"</td>");
                //out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("STOCK_MAXIMO_MATERIAL"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</td>");
                if(codAlmacen.contains("2"))
                {
                    out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadAprobadosTransitorio"))+"</td>");
                    out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadCuarentenaTransitorio"))+"</td>");
                }
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadAprobados"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadCuarentena"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadRechazados"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadVencido"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadReanalisis"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(cantidadDisponible)+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(cantidadUtilizarMaterial)+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'  class='"+(cantidadDisponible-cantidadUtilizarMaterial>0?"conexistencia":"sinexistencia")+"'>"+formato.format(cantidadDisponible-cantidadUtilizarMaterial)+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right' class='"+(cantidadDisponible-cantidadUtilizarMaterial-res.getDouble("STOCK_SEGURIDAD")>0?"conexistencia":"sinexistencia")+"'>"+formato.format(cantidadDisponible-cantidadUtilizarMaterial-res.getDouble("STOCK_SEGURIDAD"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right' class='enTransito'>"+formato.format(res.getDouble("cantidadTransito"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+(res.getTimestamp("fecha_Entrega")!=null?sdf.format(res.getTimestamp("fecha_Entrega")):"&nbsp;")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+res.getString("NOMBRE_PROVEEDOR")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+res.getString("NOMBRE_TIPO_COMPRA")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+res.getString("NOMBRE_TIPO_TRANSPORTE")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+(res.getTimestamp("FECHA_EMISION")!=null?sdf.format(res.getTimestamp("FECHA_EMISION")):"&nbsp;")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+formato.format(res.getDouble("totalSalidasAnioMovil"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+formato.format(res.getDouble("totalSalidasAnioMovilSinLote"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+formato.format(res.getDouble("totalSalidasAlmacenTrimestre"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+(res.getTimestamp("fechaUltimaSalida")!=null?sdf.format(res.getTimestamp("fechaUltimaSalida")):"&nbsp;")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+formato.format(res.getDouble("cantidadUltimaSalida"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+res.getString("codLoteUltimaSalida")+"</td>");
                //out.println("<td rowspan='"+cantidadRowSpan+"'><a href=\"../reporteExplosionProductosSimulacion/detalleDatosCompraItem.jsf?codigo="+res.getInt("cod_material")+">\" target='_BLANK'>Ver Detalles de Compra</a></td>");
                
                out.println(innerHTMLLotes.toString());
        }
        %>
            </tbody>
        </table>
        <center>
            <button class="btn" onclick="window.location.href='navegadorProgramaProduccionSimulacion.jsf?data='+(new Date()).getTime().toString();">Volver</button>
        </center>
    </body>
</html>
