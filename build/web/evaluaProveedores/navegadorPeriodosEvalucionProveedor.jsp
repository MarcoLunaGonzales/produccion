

<!doctype html>
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

<html>
    <head>

        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <link rel="STYLESHEET" type="text/css" href="../css/css_atlas.css" />
        <script src="../js/general.js"></script>
        <script>
            function validarItem(valida,locationLink){
                //alert (valida);
                //alert (locationLink);
                if(valida==1){
                    location=locationLink;
                }else{

                    alert('No se Puede Generar Porque ya hay Items Evaluados. ');
                    return false;
                }

            }

            function replicar(cod){
                //alert(cod);
                izquierda = (screen.width) ? (screen.width-300)/2 : 100
                arriba = (screen.height) ? (screen.height-400)/2 : 200
                url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';
                //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf';
                opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=350,height=250,left='+izquierda+ ',top=' + arriba + ''
                window.open(url, 'popUp',opciones)
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
            function eliminar(f)
            {
                var i;
                var j=0;
                var msj;
                var msj2;
                datos=new Array();
                for(i=0;i<=f.length-1;i++)
                {
                    if(f.elements[i].type=='checkbox')
                    {	if(f.elements[i].checked==true)
                        {	datos[j]=f.elements[i].value;
                            j=j+1;
                        }
                    }
                }
                if(j==0)
                {	alert('Debe seleccionar al menos un registro para eliminar.');
                    return(false);
                }
                else
                {
                    msj=confirm("Al eliminar la Evaluaci�n, eliminara tambien el detalle, desea continuar?");
                    if (msj==true)
                    {	msj1=confirm("La Evaluaci�n sera eliminada, desea continuar?");
                        if (msj1==true)
                        {
                            location.href="eliminarPeriodosEvaluacionProveedor.jsp?datos="+datos;
                        }
                    }
                }
            }
        </script>
    </head>
    <body>

        <form name="form1" action="registrarPeriodosEvualacionProveedor.jsp">
            <%! Connection con = null;
            %>
            <%
        con = Util.openConnection(con);
            %>
            <%
        String sql3 = "";
        String cod_tipo_inc_regional = "";
        String cod_gestion = "";
        String nombre_gestion = "";
        String cod_mes = "";
        String nombre_mes = "";
        String fecha_inicio = "";
        String fecha_final = "";


            %>
            <br>
            <h3 align="center">Periodos - Evaluacion de Proveedores</h3>
            <br>
            <table width="60%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
                <tr style="background-color:#9206A4;color:white">
                    <th height="35px" align="center" class="td">&nbsp;</th>
                    <th align="center" class="td" >Gesti�n</th>
                    <th align="center" class="td" >Mes</th>
                    <th align="center" class="td" >Fecha Inicio</th>
                    <th align="center" class="td" >Fecha Final</th>
                    <th align="center" class="td" >Generar Evaluacion</th>
                    <th align="center" class="td" >Editar Evaluacion</th>
                </tr>
                <%
        int valida = 0;
        try {


            sql3 = " select t.COD_PERIODO_EVALUACION,t.COD_GESTION,t.COD_MES,g.NOMBRE_GESTION,m.NOMBRE_MES ,isnull(t.FECHA_INICIO,'') as fecha_inicio,ISNULL(t.FECHA_FINAL, '') as fecha_final";
            sql3 += " from PERIODOS_EVALUACION_PROVEEDORES t, GESTIONES g,MESES m";
            sql3 += " where  t.cod_gestion=g.cod_gestion and t.cod_mes=m.cod_mes ";
            sql3 += " order by g.COD_GESTION desc , m.ORDEN_MES desc ";

            System.out.println("sql3=" + sql3);
            Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs3 = st3.executeQuery(sql3);
            while (rs3.next()) {

                cod_tipo_inc_regional = rs3.getString("COD_PERIODO_EVALUACION");
                cod_gestion = rs3.getString("COD_GESTION");
                cod_mes = rs3.getString("COD_MES");
                nombre_gestion = rs3.getString("NOMBRE_GESTION");
                nombre_mes = rs3.getString("NOMBRE_MES");
                Date fecha_inicio_date = rs3.getDate("fecha_inicio");
                SimpleDateFormat f = new SimpleDateFormat("dd/MM/yyyy");
                fecha_inicio = f.format(fecha_inicio_date);
                Date fecha_final_date = rs3.getDate("fecha_final");
                if (fecha_inicio.equals("01/01/1900")) {
                    fecha_inicio = "";
                }
                fecha_final = f.format(fecha_final_date);
                if (fecha_final.equals("01/01/1900")) {
                    fecha_final = "";
                }
                String sql_valida = "select isnull( SUM(e.PUNTUACION_TOTAL),0)  from EVALUACION_PROVEEDORES_MATERIAL e" +
                        " where e.COD_PERIODO_EVALUACION="+cod_tipo_inc_regional+"";
                System.out.println("sql_valida=" + sql_valida);
                Statement st_valida = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_valida = st_valida.executeQuery(sql_valida);
                while (rs_valida.next()) {
                    if (rs_valida.getInt(1) == 0) {
                        valida = 1;
                    } else {
                        valida = 0;
                    }
                }



                %>
                <tr style="border : solid #cccccc 1px;">
                    <td height="30px" class="td" >&nbsp;<input type="checkbox" name="cod_tipo_inc_regional" value="<%=cod_tipo_inc_regional%>"></td>
                    <td class="td"><%=nombre_gestion%></td>
                    <td class="td"><%=nombre_mes%></td>
                    <td class="td"><%=fecha_inicio%></td>
                    <td class="td"><%=fecha_final%></td>
                    <td align="center" class="td"><a style="color:fuchsia;cursor:pointer;" onclick="validarItem(<%=valida%>,'navegadorEvaluaProveedores.jsf?cod_tipo_inc_regional=<%=cod_tipo_inc_regional%>&cod_gestion=<%=cod_gestion%>&cod_mes=<%=cod_mes%>&nombre_mes=<%=nombre_mes%>&nombre_gestion=<%=nombre_gestion%>&fecha_inicio=<%=fecha_inicio%>&fecha_final=<%=fecha_final%>');">Generar Evaluacion</a></td>
                    <td align="center" class="td"><a style="color:fuchsia" href="navegadorEditarEvaluaProveedores.jsf?cod_tipo_inc_regional=<%=cod_tipo_inc_regional%>&cod_gestion=<%=cod_gestion%>&cod_mes=<%=cod_mes%>&nombre_mes=<%=nombre_mes%>&nombre_gestion=<%=nombre_gestion%>&fecha_inicio=<%=fecha_inicio%>&fecha_final=<%=fecha_final%>">Editar Evaluacion</a></td>
                </tr>
                <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
                %>
            </table>
            <br>
            <div align="center">
                <input type="button"   class="AA"  size="35" value="Adicionar" name="limpiar" onclick="registrar(this.form);">
                <input type="button"   class="AA"  size="35" value="Eliminar" name="limpiar"  onclick="eliminar(this.form);">

            </div>
        </form>
    </body>
</html>