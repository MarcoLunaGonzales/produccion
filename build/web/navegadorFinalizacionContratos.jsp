<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page import = "org.joda.time.DateTime"%> 
<%@ page import = "org.joda.time.Interval"%> 
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%! Connection con=null;
%>
<%
con=CofarConnection.getConnectionJsp();
%>
<%--%! 
public String verificaNroContrato(String codigoPersonal){
    con=CofarConnection.getConnectionJsp();
    String numContrato="";
    try{
        String sql=" select max(cp.numero_contrato)";
        sql+=" from CONTRATOS_PERSONAL cp,personal p";
        sql+=" where cp.COD_PERSONAL=p.COD_PERSONAL";
        sql+=" and cp.cod_personal='"+codigoPersonal+"'";
        
        System.out.println("sql:..................."+sql);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql);
        if(rs.next()){
            numContrato=rs.getString(1);
        }
    } catch(Exception e) {
    }
    return numContrato;
}
%--%>
<%! 
public String verificaNroContrato(String codigoPersonal,String nroContrato){
    con=CofarConnection.getConnectionJsp();
    int numContrato=Integer.parseInt(nroContrato)+1;
    String numContratoString=Integer.toString(numContrato);
    String bandera="0";
    try{
        String sql=" select cp.numero_contrato";
        sql+=" from CONTRATOS_PERSONAL cp,personal p";
        sql+=" where cp.COD_PERSONAL=p.COD_PERSONAL";
        sql+=" and cp.cod_personal='"+codigoPersonal+"' and numero_contrato='"+numContratoString+"'";
        
        System.out.println("sql:..................."+sql);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql);
        while (rs.next()){
            bandera="1";
            numContratoString=rs.getString(1);
        }
    } catch(Exception e) {
    }
    return bandera;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
           <title>REPORTE DE FINALIZACIÓN DE CONTRATOS</title>
        <link rel="STYLESHEET" type="text/css" href="css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
              function cancelar(){
                  // alert(codigo);
                   location='../reporteContratoFin/filtro_reporte.jsf';
                }
             function datosPersona(codigo){
                   //alert(codigo);
                   izquierda = (screen.width) ? (screen.width-300)/2 : 100 
                   arriba = (screen.height) ? (screen.height-0)/2 : 100 
                   url='../personal/datosPersonal.jsf?codigo='+codigo;
    		   opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=600,height=820,left='+izquierda+ ',top=' + arriba + '' 
   		   window.open(url, 'popUp', opciones)                
                }
               function registrar(){
                  // alert(codigo);
                   location='../personal_jsp/registrar_personal.jsf';
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
    <body background="img/fondo.jpg">
        <form>
            <br><br>
            <h3 align="center">Contratos Próximos a Finalizar</h3>
            <br>
            <%--div align="center">
                <%
                try{
                    String fechaInicio="";
                    String fechaFinal="";
                    String aux="";
                    
                    aux=request.getParameter("fecha_inicio");
                    System.out.println("ini"+aux);
                    if(!aux.equals("")){
                %>
                <b>De fecha:</b><%=aux%> 
                <%
                System.out.println("entro 1");
                String f[]=aux.split("/");
                fechaInicio=f[2]+"/"+f[1]+"/"+f[0];
                //fechaInicio=aux;
                    }
                    aux=request.getParameter("fecha_final");
                    System.out.println("fin:"+aux);
                    if(!aux.equals("")){
                %>
                <b>A fecha:</b><%=aux%> 
                <%
                System.out.println("entro 2");
                String f[]=aux.split("/");
                fechaFinal=f[2]+"/"+f[1]+"/"+f[0];
                //fechaFinal=aux;
                    }
                %>
                
                
            </div--%>
            <% int sw=0;
            try{
                Date fechaActual=new Date();
                SimpleDateFormat format=new SimpleDateFormat("yyyy/MM/dd");
                String fechaActualString=format.format(fechaActual);
                String fechaActualVector[]=fechaActualString.split("/");
                System.out.println("fechaActual :"+fechaActual);
                System.out.println("fechaActualString :"+fechaActualString);
                DateTime fechainicial=new DateTime(Integer.parseInt(fechaActualVector[0]),Integer.parseInt(fechaActualVector[1]),Integer.parseInt(fechaActualVector[2]),00,00,00,00);
                DateTime aux_fecha_inicio=fechainicial;
                
                String sql=" select dias_fin_contrato";
                sql+=" from CONFIGURACION_FIN_CONTRATOPERSONAL" +
                        " where cod_estado_registro=1 ";
                System.out.println("sql_aux:..................."+sql);
                Statement st= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs= st.executeQuery(sql);
                String dias="";
                while(rs.next()){
                    dias=rs.getString("dias_fin_contrato");
                }
                aux_fecha_inicio=aux_fecha_inicio.plusDays(Integer.parseInt(dias));
                DateTime fechafinal=aux_fecha_inicio;
                System.out.println("fechainicial :"+fechainicial);
                System.out.println("fechafinal   :"+fechafinal);
                Date fechaInicio=fechainicial.toDate();
                Date fechaFinal=fechafinal.toDate();
                String fechaInicioString=format.format(fechaInicio);
                String fechaFinalString=format.format(fechaFinal);
            %>
            
            <div align="center">
                <br><b >De Fecha : </b><%=fechaInicioString%> <b> A Fecha :</b><%=fechaFinalString%>
            </div>
            <br>
            <br>
            <table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0.5">
                <tr class="headerClassACliente" style="border : solid #cccccc 1px;" cellspacing="1">
                    
                    <td  align="center" style="border : solid #f2f2f2 0px;">Personal</td>
                    <td  align="center" style="border : solid #f2f2f2 0px;">Cargo</td>
                    <td  align="center" style="border : solid #f2f2f2 0px;">Area Empresa</td>
                    <td  align="center" style="border : solid #f2f2f2 0px;" >Nro Contrato</td>
                    <td  align="center" style="border : solid #f2f2f2 0px;" width="20%">Fecha Ingreso</td>
                    <td  align="center" style="border : solid #f2f2f2 0px;" width="20%">Fecha Salida</td>
                    <td  align="center" style="border : solid #f2f2f2 0px;">Tipo Contrato</td>
                    <td  align="center" style="border : solid #f2f2f2 0px;">&nbsp;</td>
                    
                </tr>
                <%
                
                String sql_aux=" select cp.cod_personal,p.AP_PATERNO_PERSONAL,";
                sql_aux+=" p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,cp.numero_contrato,";
                sql_aux+=" cp.fecha_ingreso,cp.fecha_salida,tcp.nombre_tipo_contratopersonal," +
                        " c.descripcion_cargo,ae.nombre_area_empresa";
                sql_aux+=" from CONTRATOS_PERSONAL cp, personal p,tipos_contratopersonal tcp,cargos c,areas_empresa ae";
                sql_aux+=" where cp.cod_tipo_contratopersonal <> 0 and p.COD_PERSONAL=cp.COD_PERSONAL" +
                        " and tcp.COD_TIPO_CONTRATOPERSONAL=cp.COD_TIPO_CONTRATOPERSONAL";
                sql_aux+=" and p.cod_estado_persona=1 and cp.FECHA_SALIDA >='"+fechaInicioString+"'" +
                        " and cp.FECHA_SALIDA<='"+fechaFinalString+"' and ae.cod_area_empresa=p.cod_area_empresa" +
                        " and c.codigo_cargo=p.codigo_cargo" ;
                sql_aux+=" order by  cp.FECHA_SALIDA,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL ";
                
                System.out.println("sql_aux:..................."+sql_aux);
                Statement st_aux = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_aux = st_aux.executeQuery(sql_aux);
                sw=0;
                while (rs_aux.next()){
                    sw=1;
                    System.out.println("entro personal");
                    String codPersonal=rs_aux.getString(1);
                    System.out.println("codPersonal:"+codPersonal);
                    String apPaterno=rs_aux.getString(2);
                    String apMaterno=rs_aux.getString(3);
                    String nombresPersonal=rs_aux.getString(4);
                    String nroContrato=rs_aux.getString(5);
                    String verifica=verificaNroContrato(codPersonal,nroContrato);
                    // if(nroContrato.equals(numeroContrato)){
                    System.out.println("1");
                    String fecha=rs_aux.getString(6);
                    System.out.println("fecha_ingreso:"+fecha);
                    String fini[]=fecha.split(" ");
                    String f[]=fini[0].split("-");
                    String fecha_1=f[2]+"/"+f[1]+"/"+f[0];
                    System.out.println("2");
                    String fecha1=rs_aux.getString(7);
                    String ffin[]=fecha1.split(" ");
                    System.out.println("fecha_salida:"+fecha1);
                    String f1[]=ffin[0].split("-");
                    String fecha_2=f1[2]+"/"+f1[1]+"/"+f1[0];
                    String nombreTipoContrato=rs_aux.getString(8);
                    System.out.println("fecha1:"+fecha1);
                    String cargo=rs_aux.getString(9);
                    String areaEmpresa=rs_aux.getString(10);
                    //System.out.println("fechaFinal:"+fechaFinal);
                
                %>
                <tr style="border : solid #cccccc 1px;">
                    <%--td style="border : solid #f3f3f3 1px;"><input type="checkbox" name="codigo" value="<%=codAudi%>" ></td--%>
                    <td style="border : solid #f3f3f3 1px;"><%=apPaterno%> <%=apMaterno%> <%=nombresPersonal%></td>
                    <td align="center" style="border : solid #f3f3f3 1px;"><%=cargo%></td>
                    <td align="center" style="border : solid #f3f3f3 1px;"><%=areaEmpresa%></td>
                    <td align="center" style="border : solid #f3f3f3 1px;"><%=nroContrato%></td>
                    <td align="center" style="border : solid #f3f3f3 1px;"><%=fecha_1%></td>
                    <td align="center" style="border : solid #f3f3f3 1px;"><%=fecha_2%></td>
                    <td align="center" style="border : solid #f3f3f3 1px;"><%=nombreTipoContrato%></td>
                    <%
                    if (verifica.equals("1")){
                    %>
                    <td align="center" style="border : solid #f3f3f3 1px;"><img src="img/estrella.jpg"></td>
                    <%
                    }else{
                    %>
                    <td align="center" style="border : solid #f3f3f3 1px;">&nbsp;</td>
                    <% 
                    }
                    %>
                    
                </tr>
                <%  
                // }
                }
            } catch(Exception e) {
            }
            if (sw==0){
                %>
                <tr style="border : solid #cccccc 1px;">
                    <%--td style="border : solid #f3f3f3 1px;"><input type="checkbox" name="codigo" value="<%=codAudi%>" ></td--%>
                    <td style="border : solid #f3f3f3 1px;">&nbsp;</td>
                    <td align="center" style="border : solid #f3f3f3 1px;">&nbsp;</td>
                    <td align="center" style="border : solid #f3f3f3 1px;">&nbsp;<b>No Existen Registros</b></td>
                    <td align="center" style="border : solid #f3f3f3 1px;">&nbsp;</td>
                    <td align="center" style="border : solid #f3f3f3 1px;">&nbsp;</td>
                    
                </tr>
                <% 
                }
                %>
            </table>
            <br>
            <div align="center">
                
                
            </div>
        </form>
    </body>
</html>
