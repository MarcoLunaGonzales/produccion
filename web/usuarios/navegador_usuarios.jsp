<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%! Connection con=null;
%>
<%
con=Util.openConnection(con);   
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
               function registrar(f){
                  alert(f.cod_modulo.value);
                  if(f.cod_modulo.value==1){
                     location="../usuarios/registrar_usuario.jsf?cod_modulo="+f.cod_modulo.value;
                  }  
                  if(f.cod_modulo.value==2){
                     location="../usuarios/registrar_usuario.jsf?cod_modulo="+f.cod_modulo.value;
                  } 
                  if(f.cod_modulo.value==3){
                     location="../usuarios_rrhh/registrar_usuario.jsf?cod_modulo="+f.cod_modulo.value;
                  } 
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
					alert('Debe seleccionar un registro para Editar sus datos.');
				}
				else
				{	
                                        if(f.cod_modulo.value==1){
                                            location.href="../usuarios/modificar_usuario.jsf?cod_modulo="+f.cod_modulo.value+"&codigo="+codigo;
                                        }
                                        if(f.cod_modulo.value==2){
                                            location.href="../usuarios/modificar_usuario.jsf?cod_modulo="+f.cod_modulo.value+"&codigo="+codigo;
                                        }
                                        if(f.cod_modulo.value==3){
                                            location.href="../usuarios_rrhh/modificar_usuario.jsf?cod_modulo="+f.cod_modulo.value+"&codigo="+codigo;
                                        }
				}
			}
		}
                
                function eliminar(f){
                    var i;
                    var j=0;
                     //alert(f.personal.value);
                     //alert(f.usuario.value);
                     //alert(f.contrasena.value);
                    codigo=new Array();
                    for(i=0;i<=f.length-1;i++)
                    {
                	if(f.elements[i].type=='checkbox')
                        {	if(f.elements[i].checked==true)
                                {	codigo[j]=f.elements[i].value;
                                	j=j+1;
                                }
                        }
                    }
                    if(j==0)
                    {	alert('Debe seleccionar almenos un Registro para ser Eliminado.');
                    }
                    else
                    {   
                        location.href="../usuarios/eliminar_usuarios.jsf?codigo="+codigo;
                    	//location.href="eliminarAreasempresaLista.do?codigo="+codigo;
                        
                        alert(codigo);
                    }
                }                   
            
   

            /*   function registrar(f){
                  // alert(codigo);
                   location='registrarDetalleModulo.jsf?cod_modulo='+f.cod_modulo.value+'&nombre_modulo='+f.nombre_modulo.value;
               }
               function cancelar(){
                  // alert(codigo);
                   location='navegadorModulos.jsf';
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
					alert('Debe seleccionar un registro para Editar sus datos.');
				}
				else
				{	
					location.href="modificar_usuario_perfil.jsf?codigo="+codigo+"&cod_perfil="+f.cod_perfil.value+"&cod_area_empresa="+f.cod_area_empresa.value+"&nombre_area_empresa="+f.nombre_area_empresa.value+"&cod_modulo="+f.cod_modulo.value;
				}
			}
		}
                
                function eliminar(f){
                    var i;
                    var j=0;
                     //alert(f.personal.value);
                     //alert(f.usuario.value);
                     //alert(f.contrasena.value);
                    codigo=new Array();
                    for(i=0;i<=f.length-1;i++)
                    {
                	if(f.elements[i].type=='checkbox')
                        {	if(f.elements[i].checked==true)
                                {	codigo[j]=f.elements[i].value;
                                	j=j+1;
                                }
                        }
                    }
                    if(j==0)
                    {	alert('Debe seleccionar almenos un Registro para ser Eliminado.');
                    }
                    else
                    {   
                        if(confirm('Desea Eliminar el Registro')){
                            if(confirm('Esta seguro de Eliminar el Registro')){
                                location.href="eliminarDetalleModulo.jsf?codigo="+codigo+"&cod_modulo="+f.cod_modulo.value+"&nombre_modulo="+f.nombre_modulo.value;
                                 return true;
                            }else{
                                return false;
                            }
                        }else{
                        return false;
                        }
                    }
                }     */    
                 function abrir(obj,codigo){
                
                   /*var nombre=obj.parentNode.parentNode.getElementsByTagName('td')[1].innerHTML;
                   var url='../usuarios/navegadorDetalleUsuarios.jsf?codigo='+codigo+'&amp;nombre='+nombre;
                 
                  location=url;*/
                  var nombre=obj.parentNode.parentNode.getElementsByTagName('td')[1].innerHTML;
                  izquierda = (screen.width) ? (screen.width-600)/2 : 100 
                  arriba = (screen.height) ? (screen.height-400)/2 : 100 
                  var url='../usuarios/navegadorDetalleUsuarios.jsf?codigo='+codigo+'&amp;nombre='+nombre;
                  //url="horariosPersonal.jsp?cod_personal="+cod_personal;
                  opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=600,height=400,left='+		izquierda+ ',top=' + arriba + '' 
                  window.open(url, 'popUp', opciones)    
                  //location=url;
                }
                
            
        </script>
    </head>
    <body>
        <form method="post" action="registrar_usuario_perfil.jsp" name="upform"  >
            <br>
            <h3 align="center"> </h3>
            <br>
            
            <%
            
            
            String codModulo = request.getParameter("codigo");
            System.out.println("codModulo:"+codModulo);
            String nombreModulo=request.getParameter("nombre");
            System.out.println("nombreModulo:"+nombreModulo);
            
            %>

            
               <div align="center" class="tituloCabeceraRRHH">
                
                Usuarios con Acceso a CRONOS
            </div>
            <br>
            
            
            <table width="100%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
                <tr class="headerClassACliente">
                    <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b>Nombre</b></td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b>Cargo</b></td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b>Area Empresa</b></td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b>Usuario</b></td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b>Password</b></td>
                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b>Detalle</b></td>
                    
                </tr>
                
                <%
                try{
                    
                    String aux="";
                    
                    //System.out.println("Personal:"+paternoPersonal+maternoPersonal+nombrePersonal);
                    String sql_aux=" select   p.cod_personal,";
                    sql_aux+="  p.ap_paterno_personal,p.ap_materno_personal,p.nombres_personal,";
                    sql_aux+="  um.nombre_usuario,um.contrasena_usuario,c.descripcion_cargo," +
                            "ae.nombre_area_empresa";
                    sql_aux+="  from personal p,usuarios_modulos um,areas_empresa ae,cargos c ";
                    sql_aux+="  where p.cod_personal = um.cod_personal and " +
                            "cod_estado_persona=1 and um.COD_MODULO='"+codModulo+"'" +
                            " and ae.cod_area_empresa=p.cod_area_empresa and " +
                            " c.codigo_cargo=p.codigo_cargo";
                    sql_aux+="  order by  p.ap_paterno_personal,p.ap_materno_personal,p.nombres_personal";
                    
                    
                    System.out.println("sql_aux:..................."+sql_aux);
                    Statement st_aux = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_aux = st_aux.executeQuery(sql_aux);
                    
                    while (rs_aux.next()){
                        System.out.println("entro personal");
                        String codPersonal=rs_aux.getString("cod_personal");
                        String paterno=rs_aux.getString("ap_paterno_personal");
                        String materno=rs_aux.getString("ap_materno_personal");
                        String nombreP=rs_aux.getString("nombres_personal");
                        String nombreUsuario=rs_aux.getString("nombre_usuario");
                        if(nombreUsuario==null){
                            nombreUsuario="";
                        }
                        System.out.println("nombreUsuario:"+nombreUsuario);
                        String contrasenaUsuario=rs_aux.getString("contrasena_usuario");
                        if(contrasenaUsuario==null){
                            contrasenaUsuario="";
                        }
                        System.out.println("contrasenaUsuario:"+contrasenaUsuario);
                        String cargo=rs_aux.getString("descripcion_cargo");
                        String areaEmpresa=rs_aux.getString("nombre_area_empresa");
                
                %>
                <tr style="border : solid #f2f2f2 1px;">
                    <td style="border : solid #f2f2f2 1px;"><input type="checkbox" name="codigo" value="<%=codPersonal%>" ></td>
                    <td style="border : solid #f2f2f2 1px;"><%=paterno%> <%=materno%> <%=nombreP%></td>
                    <td style="border : solid #f2f2f2 1px;"><%=cargo%></td>
                    <td style="border : solid #f2f2f2 1px;"><%=areaEmpresa%></td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;<%=nombreUsuario%></td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;<%=contrasenaUsuario%></td>
                    <td style="border : solid #f2f2f2 1px;"><a   onclick="abrir(this,'<%=codPersonal%>');">DETALLE</a></td>
                </tr>
                <%  
                    }
                } catch(Exception e) {
                }  
                %>
            </table>
            <input type="hidden" value="<%=codModulo%>" name="cod_modulo">
            <input type="hidden" value="<%=nombreModulo%>" name="nombre_modulo">
            <br>
            <div align="center">
                <INPUT type="button" class="btn" name="btn_registrar" value="Registrar" onClick="registrar(this.form);"  >
                <INPUT type="button" class="btn" name="btn_editar" value="Editar" onClick="editar(this.form);">
                <INPUT type="button" class="btn" name="btn_eliminar" value="Eliminar" onClick="eliminar(this.form);"  >
                <INPUT type="button" class="btn" name="btn_editar" value="Cancelar" onClick="cancelar();;">
            </div>
            
            
        </form>
    </body>
</html>

