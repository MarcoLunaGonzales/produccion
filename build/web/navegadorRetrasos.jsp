
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="org.joda.time.Duration" %>
<%@ page import="org.joda.time.Interval" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.joda.time.DateTime" %>
<%@ page import="org.joda.time.Minutes" %>

<%@page contentType="text/html"%>
<%--%@ page contentType="application/vnd.ms-excel" --%>


<%! Connection con=null;
String CadenaAreas="";
String areasDependientes="";
String sw="0";
int rango_inicio=0;
String rangoInicio="0";
String rangoFinal="0";
int rango_final=0;
%>
<%
con=CofarConnection.getConnectionJsp();
%>
<%!
public int horasretraso_entredosfechas(String fecha_inicio,String fecha_final,String codigo_persona){
    System.out.println(" horas retrasos en dos rangos de fecha por Persona");
    System.out.println("fecha_inicio"+fecha_inicio);
    System.out.println("fecha_final"+fecha_final);
    System.out.println("codigo_persona"+codigo_persona);
    int total_minutosretrasos=0;
    int minutosretrasos_dia=0;
    try{
        con=Util.openConnection(con);
        String sql="";
        sql=" select fecha_asistencia ";
        sql+=" from control_asistencia   ";
        sql+=" where  cod_personal='"+codigo_persona+"'";
        sql+=" and fecha_asistencia>='"+fecha_inicio+"'";
        sql+=" and fecha_asistencia<='"+fecha_final+"'";
        sql+=" order by fecha_asistencia asc";
        System.out.println("Control Asistencia por Persona:"+sql);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql);
        rs.last();
        int rows=rs.getRow();
        rs.first();
        for (int j=1;j<=rows;j++){
            
            SimpleDateFormat f=new SimpleDateFormat("dd-MM-yyyy");
            minutosretrasos_dia=horasretraso_dia(f.format(rs.getDate("fecha_asistencia")).toString(),codigo_persona);
            total_minutosretrasos=total_minutosretrasos+minutosretrasos_dia;
            
            rs.next();
        }
        if(total_minutosretrasos>=rango_inicio && total_minutosretrasos<=rango_final){
            
        } else{
            total_minutosretrasos=0;
        }
        
    } catch(Exception e) {
        e.printStackTrace();
    }
    return total_minutosretrasos;
}
%>
<%!
public int [] cargar_fechahora_envector(String fecha) {
    int [] asistencia=new int [100];
    System.out.println("fecha"+fecha);
    String []fecha_hora_recibida=fecha.split(" ");
    String fecha1=fecha_hora_recibida[0];
    String hora1=fecha_hora_recibida[1];
    String[] fecha1_vector=fecha1.split("-");
    String[] hora1_vector=hora1.split(":");
    asistencia[0] =Integer.parseInt(fecha1_vector[0]);
    asistencia[1] =Integer.parseInt(fecha1_vector[1]);
    asistencia[2] =Integer.parseInt(fecha1_vector[2]);
    asistencia[3] =Integer.parseInt(hora1_vector[0]);
    asistencia[4] =Integer.parseInt(hora1_vector[1]);
    asistencia[5] =0;
    asistencia[6] =0;
    return(asistencia);
}
%>
<%!
public int  difminutos_entreasistencia_horario(int[] asistencia,int [] horario){
    int minutos=0;
    DateTime asistencia1= new DateTime(asistencia[0],asistencia[1],asistencia[2],asistencia[3],asistencia[4],asistencia[5],asistencia[6]);
    DateTime horario1= new DateTime(horario[0],horario[1],horario[2],horario[3],horario[4],horario[5],horario[6]);
    minutos = Minutes.minutesBetween(asistencia1,horario1).getMinutes();
// System.out.println("minutos"+minutos);
    if(minutos<0){
        minutos=0;
    }
    return (minutos);
}
%>
<%!
public int horasretraso_dia(String fecha,String codigo_persona){
    
    System.out.println(" PROCESO HORAS EXTRA POR DIA");
    System.out.println("fecha_ que mandamos"+fecha);
    System.out.println("codigo_persona"+codigo_persona);
    int total_minutosretrasos=0;
    String minutosretrasos_dia="";
    int cod_horario=0;
    int cod_dia_semana=0;
    int minutos_ingresoretraso1=0;
    int minutos_salidaretraso1=0;
    int minutos_ingresoretraso2=0;
    int minutos_salidaretraso2=0;
    int minutos_tolerancia_retraso=0;
    int [] ingreso1_asistencia = null;
    int [] ingreso1_horario=null;
    int [] salida1_asistencia = null;
    int [] salida1_horario=null;
    int [] ingreso2_asistencia = null;
    int [] ingreso2_horario=null;
    int [] salida2_asistencia = null;
    int [] salida2_horario=null;
    String hora_ingreso1_asistencia="";
    String hora_salida1_asistencia="";
    String hora_ingreso2_asistencia="";
    String hora_salida2_asistencia="";
    String hora_ingreso1_horario="";
    String hora_salida1_horario="";
    String hora_ingreso2_horario="";
    String hora_salida2_horario="";
    String[] fecha_vector=null;
    String subtotal1="";
    String subtotal2="";
    String total="";
    String hora="";
    try{
        con=Util.openConnection(con);
        cod_horario=verifica_si_tiene_horario(fecha,codigo_persona);
        
        String sql2="";
        sql2="select minutos_tolerancia";
        sql2+=" from tolerancia where cod_tolerancia=1";
        Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs2=st2.executeQuery(sql2);
        rs2.last();
        rs2.first();
        int rows2=rs2.getRow();
        if(rows2>0){
            minutos_tolerancia_retraso=rs2.getInt("minutos_tolerancia");
        }else{
            minutos_tolerancia_retraso=0;
        }
        fecha_vector=fecha.split("-");
        String fecha1=fecha_vector[1]+"-"+fecha_vector[0]+"-"+fecha_vector[2];
        System.out.println("fecha convertida :"+fecha1);
        
        if(cod_horario==0){
            total_minutosretrasos=0;
        }else{
            
            DateTime inicial=new DateTime(Integer.parseInt(fecha_vector[2]),Integer.parseInt(fecha_vector[1]),Integer.parseInt(fecha_vector[0]),00,00,00,00);
            cod_dia_semana=inicial.getDayOfWeek();
            System.out.println("dia de la semana: "+cod_dia_semana);
            String sql1="";
            sql1="select ISNULL(hora_ingreso1,'01-01-1900') as hora_ingreso1,";
            sql1+=" ISNULL(hora_salida1,'01-01-1900') as hora_salida1," ;
            sql1+=" ISNULL(hora_ingreso2,'01-01-1900')as hora_ingreso2," ;
            sql1+=" ISNULL(hora_salida2,'01-01-1900') as hora_salida2";
            sql1+=" from control_asistencia ";
            sql1+=" where cod_personal="+codigo_persona;
            sql1+=" and fecha_asistencia='"+fecha1+"'";
            System.out.println("sql ingreso 1"+sql1);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql1);
            rs.last();
            rs.first();
            int rows1=rs.getRow();
            if(rows1>0){
                hora_ingreso1_asistencia=rs.getString("hora_ingreso1");
                hora_salida1_asistencia=rs.getString("hora_salida1");
                hora_ingreso2_asistencia=rs.getString("hora_ingreso2");
                hora_salida2_asistencia=rs.getString("hora_salida2");
            }
            
            String sql="";
            sql="select ISNULL(hora_ingreso1,'01-01-1900') as hora_ingreso1,";
            sql+=" ISNULL(hora_salida1,'01-01-1900') as hora_salida1," ;
            sql+=" ISNULL(hora_ingreso2,'01-01-1900')as hora_ingreso2," ;
            sql+=" ISNULL(hora_salida2,'01-01-1900') as hora_salida2";
            sql=sql+" from horario_detalle ";
            sql=sql+" where cod_dia_semana="+cod_dia_semana;
            sql=sql+" and cod_horario="+cod_horario;
            System.out.println("sql ingreso 2"+sql);
            Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1=st1.executeQuery(sql);
            rs1.last();
            rs1.first();
            int rows=rs1.getRow();
            if(rows==0){
                total_minutosretrasos=0;
            } else{
                hora_ingreso1_horario=rs1.getString("hora_ingreso1");
                hora_salida1_horario=rs1.getString("hora_salida1");
                hora_ingreso2_horario=rs1.getString("hora_ingreso2");
                hora_salida2_horario=rs1.getString("hora_salida2");
                String fecha_date2=fecha_vector[2]+"-"+fecha_vector[1]+"-"+fecha_vector[0];
                
                if(!hora_ingreso1_asistencia.equals("1900-01-01 00:00:00.0") && !hora_ingreso1_horario.equals("") ) {
                    ingreso1_asistencia=cargar_fechahora_envector(hora_ingreso1_asistencia);
                    ingreso1_horario=cargar_fechahora_envector((fecha_date2+" "+hora_ingreso1_horario));
                    minutos_ingresoretraso1=difminutos_entreasistencia_horario(ingreso1_horario,ingreso1_asistencia);
                    System.out.println("miminutos_ingresoretraso1 :"+minutos_ingresoretraso1);
                    if(minutos_tolerancia_retraso>=minutos_ingresoretraso1){minutos_ingresoretraso1=0;}
                    System.out.println("miminutos_ingresoretraso1 :"+minutos_ingresoretraso1);
                }else{
                    minutos_ingresoretraso1=0;
                }
                
                
                if(!hora_ingreso2_asistencia.equals("1900-01-01 00:00:00.0") && !hora_ingreso2_horario.equals("") ) {
                    ingreso2_asistencia=cargar_fechahora_envector(hora_ingreso2_asistencia);
                    ingreso2_horario=cargar_fechahora_envector((fecha_date2+" "+hora_ingreso2_horario));
                    minutos_ingresoretraso2=difminutos_entreasistencia_horario(ingreso2_horario,ingreso2_asistencia);
                    System.out.println("minutos_ingresoretraso2 :"+minutos_ingresoretraso2);
                    if(minutos_tolerancia_retraso>=minutos_ingresoretraso2){minutos_ingresoretraso2=0;}
                    System.out.println("minutos_ingresoretraso2 :"+minutos_ingresoretraso2);
                }else{
                    minutos_ingresoretraso2=0;
                }
                
                
                total_minutosretrasos=minutos_ingresoretraso1+minutos_ingresoretraso2;
                
            }
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
    return total_minutosretrasos;
}
%>
<%!
public int verifica_si_tiene_horario(String fecha_asistencia,String codigo_persona){
    System.out.println("verifica si tiene horario");
    System.out.println("FECHA VREIFICA  :"+fecha_asistencia);
    int cod_horario=0;
    String[] fecha_asistencia_vector=null;
    try{
        fecha_asistencia_vector=fecha_asistencia.split("-");
        String fecha_asistencia1=fecha_asistencia_vector[1]+"-"+fecha_asistencia_vector[0]+"-"+fecha_asistencia_vector[2];
        System.out.println("fecha convertida :"+fecha_asistencia1);
        con=Util.openConnection(con);
        int minutos_diferencia=0;
        String sql_horario="";
        String sql="";
        sql=" select top 1 cod_horario,fecha_asignacion_horario";
        sql+=" from horarios_empleado ";
        sql+=" where  cod_personal='"+codigo_persona+"'";
        sql+=" and  fecha_asignacion_horario<='"+fecha_asistencia1+"' order by fecha_asignacion_horario desc";
        System.out.println("Control Asistencia por Persona:"+sql);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql);
        rs.last();
        rs.first();
        int rows=rs.getRow();
        if(rows==0){
            cod_horario=0;
        } else{
            cod_horario=rs.getInt("cod_horario");
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
    System.out.println("cod_horario"+cod_horario);
    return cod_horario;
}
%>
<%!
public String generaCadenaAreasEmpresa(String codigo){
    
    try {
        con=CofarConnection.getConnectionJsp();
        String sql1="select  cod_area_inferior from areas_dependientes_inmediatas ";
        sql1+=" where cod_area_empresa="+codigo;
        sql1+=" order by nro_orden asc";
        System.out.println("sql1_areadependiente:"+sql1);
        Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs1=st1.executeQuery(sql1);
//CadenaAreas=CadenaAreas+"-"+codigo;
        
        while (rs1.next()){
            CadenaAreas=CadenaAreas+","+rs1.getString("cod_area_inferior");
            generaCadenaAreasEmpresa(rs1.getString("cod_area_inferior"));
            
//System.out.println("cod_area_inferior INFERIOR:"+rs1.getString("cod_area_inferior"));
        }
        if(rs1!=null){
            rs1.close();
            st1.close();
        }
    } catch (SQLException s) {
        s.printStackTrace();
    }
    return CadenaAreas;
}
%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>REPORTE DE RETRASOS</title>
        <link rel="STYLESHEET" type="text/css" href="css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
              function cancelar(){
                  // alert(codigo);
                   location='filtro_reporte_resumido.jsf';
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
    <body >
        <form>
            <br><br>
            <h3 align="center">Reporte de Retrasos </h3>
            <br>
            <div align="center">
                <table>
                    <tr>
                        <%
                        //String checkedDependencia=request.getParameter("dependencias");
                        String codAreaEmpresa="91";
                        areasDependientes=generaCadenaAreasEmpresa(codAreaEmpresa);
                        String fecha_reporte="";
                        try{
                            String sql_pre=" select top 1 fecha_asistencia from CONTROL_ASISTENCIA ";
                            sql_pre+=" order by fecha_asistencia desc";
                            System.out.println("sql control asistencia..................."+sql_pre);
                            Statement st_pre = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs_pre= st_pre.executeQuery(sql_pre);
                            while(rs_pre.next()){
                                Date fecha=rs_pre.getDate(1);
                                SimpleDateFormat f=new SimpleDateFormat("yyyy/MM/dd");
                                fecha_reporte=f.format(fecha);
                            }
                            
                        }  catch(Exception e) {
                        }
                        rangoInicio="1";
                        rango_inicio=1;
                        System.out.println("rango_inicio:"+rango_inicio);
                        rangoFinal="50";
                        rango_final=50;
                        System.out.println("rango_final:"+rango_final);
                        String nombreAreaEmpresa="";
                        String cod_area_raiz="";
                        
                        String fechaInicio="";
                        String fechaFinal="";
                        String aux="";
                        String mesInicio="";
                        String mesFinal="";
                        String fechaReporte=fecha_reporte;
                        String f[]=fecha_reporte.split("/");
                        fecha_reporte=f[2]+"/"+f[1]+"/"+f[0];
                        System.out.println("fecha_reporte"+fecha_reporte);
                        if(!fecha_reporte.equals("")){
                        %>
                        <td align="left"><b>De fecha</b> </td> 
                        <td align="left">:</td> 
                        <td align="left"><%=fecha_reporte%> </td> 
                        <%
                        }
                        %>
                    </tr>
                </table> 
            </div>
            <br><br>
            <table  align="center" class="outputText2" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;" >
                <tr class="headerClassACliente">
                    <th  align="center" style="border : solid #f2f2f2 1px;">Nro</th>
                    <th  align="center" style="border : solid #f2f2f2 1px;">Nombres</th>
                    <th  align="center" style="border : solid #f2f2f2 1px;">Cargo</th>
                    <th  align="center" style="border : solid #f2f2f2 1px;">Area Empresa</th>
                    <th  align="center" style="border : solid #f2f2f2 1px;">Minutos Retraso</th>
                </tr>
                <%
                try{
                    System.out.println("entroooo"+areasDependientes);
                    String areasEmpresaVector[]=areasDependientes.split(",");
                    int nro=0;
                    for(int i=0;i<=areasEmpresaVector.length-1;i++){
                        
                        String sql="select distinct (p.cod_personal),p.ap_paterno_personal,p.ap_materno_personal,p.NOMBRES_PERSONAL,c.DESCRIPCION_CARGO," ;
                        sql+=" ae.nombre_area_empresa, p.sexo_personal" ;
                        sql+=" from personal p,cargos c,areas_empresa ae,control_asistencia ca" ;
                        sql+=" where ae.cod_area_empresa=p.cod_area_empresa" ;
                        sql+=" and c.CODIGO_CARGO=p.CODIGO_CARGO " ;
                        sql+=" and fecha_asistencia>='"+fechaReporte+"' and fecha_asistencia<='"+fechaReporte+"'" ;
                        sql+=" and p.cod_personal=ca.cod_personal" ;
                        sql+=" and p.cod_area_empresa='"+areasEmpresaVector[i]+"' and cod_estado_persona=1" ;
                        
                        System.out.println("sql Descuentos..................."+sql);
                        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs= st.executeQuery(sql);
                        int count=0;
                        String cabeceraDescuentosTabla="";
                        while (rs.next()){
                            System.out.println("entro 32432532");
                            
                            String codPersonal=rs.getString("cod_personal");
                            String apPaternoPersonal=rs.getString("ap_paterno_personal");
                            String apMaternoPersonal=rs.getString("ap_materno_personal");
                            String nombresPersonal=rs.getString("NOMBRES_PERSONAL");
                            String nombreCargo=rs.getString("DESCRIPCION_CARGO");
                            String nombreareaEmpresa=rs.getString("nombre_area_empresa");
                            int sexo_personal=rs.getInt("sexo_personal");
                            System.out.println("fechaInicio:"+fechaInicio);
                            int horas_retraso=horasretraso_entredosfechas(fechaReporte,fechaReporte,codPersonal);
                            if(horas_retraso!=0){
                                nro++;
                %>
                <tr>
                    <td valign="top"  style="border : solid #f2f2f2 1px;"><%=nro%></td>
                    <td valign="top"  style="border : solid #f2f2f2 1px;"><%=apPaternoPersonal%> <%=apMaternoPersonal%> <%=nombresPersonal%></td>
                    <td valign="top"  style="border : solid #f2f2f2 1px;"><%=nombreCargo%></td>
                    <td valign="top"  style="border : solid #f2f2f2 1px;"><%=nombreareaEmpresa%></td>
                    <td align="RIGHT"  style="border : solid #f2f2f2 1px;"><%=horas_retraso%></td>
                    
                </tr>
                <%
                            }
                        }
                    }
                } catch(Exception e) {
                }
                %>
            </table>
            <br>
            <div align="center">
                
                <%--input type="button"   class="btn"  size="35" value="Cancelar" name="limpiar" onclick="cancelar();"--%>
            </div>
        </form>
    </body>
</html>
