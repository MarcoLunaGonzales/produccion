package reportesExistenciasVentas;

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.sql.*"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import = "java.util.ArrayList"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page language="java" import="javazoom.upload.*,java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%! Connection con=null;


String codPresentacion="";
String nombrePresentacion="";
String linea_mkt="";
String agenciaVenta="";
%>
<%! public String nombrePresentacion1(){
    con=CofarConnection.getConnectionJsp();
    String  nombreproducto="";
    try{
        
        String sql_aux="select p.cod_prod,p.nombre_prod, ";
        sql_aux+=" (select sp.nombre_sabor from SABORES_PRODUCTO sp where sp.COD_SABOR =cp.COD_SABOR and cp.cod_sabor<>0) as nombreSabor,";
        sql_aux+=" cp.VOLUMENPESO_ENVASEPRIM,";
        sql_aux+=" (select es.NOMBRE_ENVASESEC from ENVASES_SECUNDARIOS es where es.COD_ENVASESEC = pp.COD_ENVASESEC) as nombreEnvaseSec,";
        sql_aux+=" pp.cantidad_presentacion,";
        sql_aux+=" (select ff.nombre_forma from FORMAS_FARMACEUTICAS ff where ff.cod_forma= cp.cod_forma) as nombreForma ";
        sql_aux+=" from COMPONENTES_PROD cp, COMPONENTES_PRESPROD cpp, PRESENTACIONES_PRODUCTO pp, PRODUCTOS p";
        sql_aux+=" where cp.COD_COMPPROD = cpp.COD_COMPPROD";
        sql_aux+=" and cpp.COD_PRESENTACION = pp.cod_presentacion";
        sql_aux+=" and cp.COD_PROD = p.cod_prod ";
        sql_aux+=" and pp.cod_presentacion='"+codPresentacion+"'";
        System.out.println("PresentacionesProducto:sql:"+sql_aux);
//setCon(Util.openConnection(getCon()));
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql_aux);
        while (rs.next()){
            String codigo=rs.getString(1);
            nombreproducto=rs.getString(2)+" ";
            String aux=rs.getString(3);
            System.out.println("aux:"+aux);
            if(aux!=null){
                nombrePresentacion+=aux+" ";
            }
            nombreproducto+=rs.getString(4)+" "+rs.getString(5)+" x "+rs.getString(6)+" "+rs.getString(7);
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
             function datosPersona(codigo){
                   //alert(codigo);
                   izquierda = (screen.width) ? (screen.width-300)/2 : 100 
                   arriba = (screen.height) ? (screen.height-0)/2 : 100 
                   url='../personal/datosPersonal.jsf?codigo='+codigo;
    		   opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=600,height=820,left='+izquierda+ ',top=' + arriba + '' 
   		   window.open(url, 'popUp', opciones)                
                }
               function cancelar(){
                  // alert(codigo);
                   location='../reporteMovimientoArticulos/filtro_reporte.jsf';
                }
               function editar(f)
		{
			var i;
			var j=0;
			var dato;
			var codigo;
			for(i=0;i<=f.length-1;i++)
			{
				if(f.elements[i].type=='checkbox')
				{	if(f.elements[i].checked==true)
					{	
						codigo=f.elements[i].value;
						j=j+1;
					}
				}
			}

			if(j>1)
			{	alert('Debe seleccionar solo un registro.');
			}
			else
			{
				if(j==0)
				{
					alert('Debe seleccionar un registro para editar sus datos.');
				}
				else
				{	
					location.href="modificar_personal.jsf?codigo="+codigo;
				}
			}
		}
                function estadosPersona(f){
                    //alert();
                    var x=f.estados_personal;
                    //alert(x.value);
                    location.href="navegador_personal.jsf?cod_estado_personal="+x.value;
                }
                function areaEmpresa(f){
                    //alert();
                    var x=f.area_empresa;
                    //alert(x.value);
                    location.href="navegador_personal.jsf?area_empresa="+x.value;
                }
                
        </script>
    </head>
    <body>
        <form>
            <br><br>
            <h3 align="center">Reporte de Movimiento de Artículos </h3>
            
    
            
            
            <%
            try{
                String fechaInicio="";
                String fechaFinal="";
                String agencia="";
                String pilar="";
                String aux="";
                 con=Util.openConnection(con);
                aux=request.getParameter("agencia");
                System.out.println("aux:"+aux);
                if(aux!=null){
                    try{
                        //con=CofarConnection.getConnectionJsp();
                        String sql_aux="select ae.nombre_area_empresa from areas_empresa ae,agencias_venta av" +
                                " where av.cod_area_empresa=ae.cod_area_empresa and av.cod_area_empresa='"+aux+"'";
                        System.out.println("agencia:"+sql_aux);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs=st.executeQuery(sql_aux);
                        while (rs.next()){
                            agenciaVenta="";
                            agenciaVenta=rs.getString(1);
                            System.out.println("agenciaVenta:"+agenciaVenta);
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    agencia=aux;
                }
                aux=request.getParameter("fecha_inicio");
                System.out.println("aux:"+aux);
                if(aux!=null){
                    System.out.println("entro");
                    fechaInicio=aux;
                }
                System.out.println("fechaInicio:"+fechaInicio);
                aux=request.getParameter("fecha_final");
                if(aux!=null){
                    fechaFinal=aux;
                }
                aux=request.getParameter("pilar");
                if(aux!=null){
                    try{
                        
                        String sql_aux="select nombre_lineamkt from lineas_mkt " +
                                " where cod_lineamkt='"+aux+"'";
                        System.out.println("pilar:"+sql_aux);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs=st.executeQuery(sql_aux);
                        while (rs.next()){
                            linea_mkt="";
                            linea_mkt=rs.getString(1);
                            System.out.println("linea_mkt:"+linea_mkt);
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    pilar=aux;
                }
            
            
            %>
            <div align="center">
                <b>De fecha :</b>De fecha :<%=fechaInicio%>  <b>A fecha :</b><%=fechaFinal%>
                <br><br>
                <b>Pilar :</b><%=linea_mkt%>    <b>Agencia :</b><%=agenciaVenta%> 
            </div>
            <br> <table width="90%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
                <tr class="headerClassACliente">
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;">Artículo</td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;">Presentación</td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;">Saldo : <%=fechaInicio%></td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;">Ingresos</td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;">Salidas</td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;">Saldo: <%=fechaFinal%></td>
                </tr>
                
                <%
                String sql="";
                sql="select cod_prod,nombre_prod from productos order by nombre_prod";
                
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(sql);
                while (rs.next()){
                    String codProd=rs.getString(1);
                    String nombreProd=rs.getString(2);
                    System.out.println("nombreProd:"+nombreProd);
                    String sql_4="select cod_presentacion,cantidad_presentacion from presentaciones_producto " +
                            " where cod_prod='"+codProd+"'" ;
                    System.out.println("SQL_4:"+sql_4);
                    Statement st_4=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_4=st_4.executeQuery(sql_4);
                    while (rs_4.next()){
                        codPresentacion="";
                        codPresentacion=rs_4.getString(1);
                        String cantPresentacion=rs_4.getString(2);
                        String nombre=nombrePresentacion1();
                        String sql_2="select id.cantidad,id.cantidad_unitaria,id.costo_almacen " +
                                " from ingresos_detalleventas id,ingresos_ventas iv " +
                                " where id.cod_ingresoventas=iv.cod_ingresoventas "+
                                " and id.cod_presentacion="+codPresentacion+" and iv.fecha_ingresoventas<='"+fechaInicio+ "' and iv.cod_almacen_venta="+agencia;
                        System.out.println("SQL_2:"+sql_2);
                        Statement st_2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_2=st_2.executeQuery(sql_2);
                        float sumIngresos=0;
                        while (rs_2.next()){
                            sumIngresos=(rs_2.getFloat(1)+rs_2.getFloat(2)/Float.parseFloat(cantPresentacion))*Float.parseFloat(rs_2.getString(3));
                        }
                        if(rs_2!=null){
                            rs_2.close();st_2.close();
                            
                        }
                        float sumSalidas=0;
                        String sql_3="select sd.cantidad,sd.cantidad_unitaria,sd.costo_almacen " +
                                " from salidas_detalleventas sd,salidas_ventas sa " +
                                " where sd.cod_salidaventas=sa.cod_salidaventa " +
                                " and sd.cod_presentacion="+codPresentacion+""+
                                " and sa.fecha_salidaventa<='"+fechaInicio+ "' and sa.cod_almacen_venta="+agencia;
                        System.out.println("SQL_3:"+sql_3);
                        Statement st_3=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_3=st_3.executeQuery(sql_3);
                        while (rs_3.next()){
                            sumSalidas=(rs_3.getFloat(1)+rs_3.getFloat(2)/Float.parseFloat(cantPresentacion))*Float.parseFloat(rs_3.getString(3));
                        }
                        if(rs_3!=null){
                            rs_3.close();st_3.close();
                            
                        }
                        
                        
                        String sql_5="select id.cantidad,id.cantidad_unitaria,id.costo_almacen " +
                                " from ingresos_detalleventas id,ingresos_ventas iv " +
                                " where id.cod_ingresoventas=iv.cod_ingresoventas "+
                                " and id.cod_presentacion="+codPresentacion+" " +
                                " and iv.fecha_ingresoventas>='"+fechaInicio+ "' " +
                                " and iv.fecha_ingresoventas<='"+fechaFinal+ "' " +
                                " and iv.cod_almacen_venta="+agencia;
                        System.out.println("SQL_5:"+sql_5);
                        Statement st_5=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_5=st_5.executeQuery(sql_5);
                        float sumIngresos_1=0;
                        while (rs_5.next()){
                            sumIngresos_1=(rs_5.getFloat(1)+rs_5.getFloat(2)/Float.parseFloat(cantPresentacion))*Float.parseFloat(rs_5.getString(3));
                        }
                        if(rs_5!=null){
                            rs_5.close();st_5.close();
                            
                        }
                        
                        float sumSalidas_1=0;
                        String sql_6="select sd.cantidad,sd.cantidad_unitaria,sd.costo_almacen " +
                                " from salidas_detalleventas sd,salidas_ventas sa " +
                                " where sd.cod_salidaventas=sa.cod_salidaventa " +
                                " and sd.cod_presentacion="+codPresentacion+""+
                                " and sa.fecha_salidaventa>='"+fechaInicio+ "' " +
                                " and sa.fecha_salidaventa<='"+fechaFinal+ "' and sa.cod_almacen_venta="+agencia;
                        System.out.println("SQL_6:"+sql_6);
                        Statement st_6=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_6=st_6.executeQuery(sql_6);
                        while (rs_6.next()){
                            sumSalidas_1=(rs_6.getFloat(1)+rs_6.getFloat(2)/Float.parseFloat(cantPresentacion))*Float.parseFloat(rs_6.getString(3));
                        }
                        if(rs_6!=null){
                            rs_6.close();st_6.close();
                            
                        }
                        
                        System.out.println("---------------------"+sumIngresos_1+"-"+sumSalidas_1+"="+(sumIngresos_1-sumSalidas_1));
                        //System.out.println("---------------------"+ingresos_unitarios+"-"+salidas_unitarios+"="+(ingresos_unitarios-salidas_unitarios));
                        //values[3]=String.valueOf(ingresos-salidas);
                        //values[4]=String.valueOf(ingresos_unitarios-salidas_unitarios);
                        //getDetalleExistencia().add(values);
                %>    
                <tr>
                    <td class=colh  style="border : solid #f2f2f2 1px;"><%=nombreProd%></td>
                    <td class=colh  style="border : solid #f2f2f2 1px;"><%=nombre%></td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"><%=sumIngresos-sumSalidas%></td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"><%=sumIngresos_1%></td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"><%=sumSalidas_1%></td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"><%=(sumIngresos-sumSalidas)+(sumIngresos_1-sumSalidas_1)%></td>
                    
                    
                </tr>
                <% }
                }
                
                %>
                
                <%  
                
                } catch(Exception e) {
                }
                %>
            </table>
            <br>
            <div align="center">
                <INPUT type="button" class="btn" name="btn_registrar" value="Cancelar" onClick="cancelar();"  >
                
            </div>
        </form>
    </body>
</html>
