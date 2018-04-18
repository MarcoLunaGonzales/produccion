<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>


<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script type="text/javascript" src="../../js/general.js"></script>
        <script language="javascript">
            function calculoStockMateriales(f)
            {
                var arrayCodGrupo=new Array();
                var arrayNombreGrupo=new Array();
                for(var i=0;i<=f.codGrupo.options.length-1;i++)
                {
                    if(f.codGrupo.options[i].selected)
                    {
                        arrayCodGrupo.push(f.codGrupo.options[i].value);
                        arrayNombreGrupo.push(f.codGrupo.options[i].innerHTML);
                    }
                }
                var arrayCodAlmacen = new Array();
                var arrayNombreAlmacen = new Array();
                for(var i=0;i<=f.codAlmacen.options.length-1;i++)
                {
                    if(f.codAlmacen.options[i].selected)
                    {	
                        arrayCodAlmacen.push(f.codAlmacen.options[i].value);
                        arrayNombreAlmacen.push(f.codAlmacen.options[i].innerHTML);
                    }
                }
                f.codAlmacenP.value = arrayCodAlmacen;
                f.nombreAlmacenP.value = arrayNombreAlmacen;
                f.codGrupoP.value=arrayCodGrupo;
                f.nombreGrupoP.value=arrayNombreGrupo;
                f.action="navegadorReporteCalculoStocksOtros.jsf";
                f.submit();
            }

            function capitulo_change(f)
            {
                var arrayCodCapitulo=new Array();
                for(var i=0;i<=f.codCapitulo.options.length-1;i++)
                {	
                    if(f.codCapitulo.options[i].selected)
                    {
                        arrayCodCapitulo.push(f.codCapitulo.options[i].value);
                    }
                }
                var ajax=creaAjax();
                var url='grupoAjax.jsp?codCapitulo='+arrayCodCapitulo+'&random='+(new Date()).getTime().toString();
                ajax.open ('GET', url, true);
                ajax.onreadystatechange = function() {
                    if (ajax.readyState==1) {
                    }else if(ajax.readyState==4){
                        if(ajax.status==200){
                            //alert(ajax.responseText);
                            var divGrupo=document.getElementById('div_grupo');
                            divGrupo.innerHTML=ajax.responseText;
                        }
                    }
                }
                ajax.send(null);
            }




        </script>
    </head>
    <body>
        <span class="outputTextTituloSistema">Calculo de Stocks</span>
        <form method="post" action="navegadorReporteEvaluacionStocks.jsf" name="form1" target="_blank">
            <div align="center">
                <table border="0" class="tablaFiltroReporte" cellspacing="0" cellpadding="0">
                    <thead>
                        <tr>
                            <td  colspan="3" >Introduzca los Parámetros del Reporte</td>
                        </tr>
                    </thead>
                    <tr>
                        <td class="outputTextBold">Capitulo</td>
                        <td class="outputTextBold">::</td>
                        <td>
                            <select name="codCapitulo" id="codCapitulo" class="inputText" onchange="capitulo_change(form1)" multiple size="6">
                        <%
                            Connection con=null;
                            try {
                                con = Util.openConnection(con);
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                StringBuilder consulta=new StringBuilder("select c.COD_CAPITULO,c.NOMBRE_CAPITULO");
                                                        consulta.append(" from CAPITULOS c");
                                                        consulta.append(" where c.COD_CAPITULO in (10,7,17,18,11)");
                                                        consulta.append(" order by c.NOMBRE_CAPITULO");
                                ResultSet res=st.executeQuery(consulta.toString());
                                while(res.next())
                                {
                                    out.println("<option value='"+res.getInt("COD_CAPITULO")+"'>"+res.getString("NOMBRE_CAPITULO")+"</option>");
                                }
                        %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="outputTextBold">Grupo</td>
                        <td class="outputTextBold">::</td>
                        <td>
                            <div id="div_grupo">
                                <select name="codGrupo" id="codGrupo" class="inputText" multiple >
                                    <option>Seleccione un capitulo</option>
                                </select>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td class="outputTextBold">Almacen</td>
                        <td class="outputTextBold">::</td>
                        <td>
                            <select name="codAlmacen" id="codAlmacen" class="inputText" multiple size="10">
                        <%
                            consulta=new StringBuilder("select a.COD_ALMACEN,a.NOMBRE_ALMACEN");
                                        consulta.append(" from almacenes a");
                                        consulta.append(" where a.COD_ESTADO_REGISTRO = 1");
                            res=st.executeQuery(consulta.toString());
                            while(res.next())
                            {
                                out.println("<option value='"+res.getInt("COD_ALMACEN")+"'>"+res.getString("NOMBRE_ALMACEN")+"</option>");
                            }
                        }
                        catch(SQLException ex)
                        {
                                ex.printStackTrace();
                        }
                        finally
                        {
                                con.close();
                        }
                        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                        %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" class="tdCenter">
                            <a class="btn" onclick="calculoStockMateriales(form1)">Ver Reporte</a>
                            <input type="reset"   class="btn"  size="35" value="Limpiar" name="limpiar">
                        </td>
                    </tr>
                </table>
            </div>
           


            <input type="hidden" name="codAlmacenVentaP">
            <input type="hidden" name="codTipoClienteP">
            <input type="hidden" name="nombreAlmacenVentaP">
            <input type="hidden" name="nombreTipoClienteP">
            <input type="hidden" name="fechaFinalP">
            <input type="hidden" name="codGrupoP">
            <input type="hidden" name="nombreGrupoP">

            <input type="hidden" name="codAlmacenP">
            <input type="hidden" name="nombreAlmacenP">

        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>