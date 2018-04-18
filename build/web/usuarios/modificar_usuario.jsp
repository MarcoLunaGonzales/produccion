<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@ page language="java"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>




<html>
    
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
               function cancelar(){
                  // alert(codigo);
                   location='../usuarios/navegador_usuarios.jsf?codigo=1';
                }
                function editar(f){
                    var formulario=document.getElementById('upform');
                    var data=document.getElementById('codigo');
                    var i;
                    var j=0;
                    
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
                    {	alert('Debe seleccionar almenos un Registro para ser Registrado.');
                    }
                    else
                    {   data.value=codigo;
                        //location="guardar_modificar_usuarios.jsf?codigo="+codigo+"&personal="+f.personal.value+"&usuario="+f.usuario.value+"&contrasena="+f.contrasena.value+"&cod_modulo="+f.cod_modulo.value;
                         formulario.submit();   
                    	
                        
                       
                    }
                }      
    function areas(codigo){
            
        var ajax=creaAjax();
        var url='../personal_jsp/areaempresaajax.jsp?codigo='+codigo;
        url+='&pq='+(Math.random()*1000);
        ajax.open ('GET', url, true);
        ajax.onreadystatechange = function() {
        //alert(ajax.readyState);           
           if (ajax.readyState==1) {
 
           }else if(ajax.readyState==4){
                    if(ajax.status==200){
                      //alert(ajax.responseText);
                        var maindiv=document.getElementById('maindiv');
                       maindiv.innerHTML=ajax.responseText;
                      
                      
                        

                    }
          }
        }
        ajax.send(null);
    }

           
            
        /*}*/
        </script>
    </head>
    <body>
        
        <%! 
        Connection con=null;
        String codVentanaHijo="";
        String generaArbol[]=new String[1000];
        int k=0;
        String codigo="";
        %>
        <%
        con=CofarConnection.getConnectionJsp();    
        %>
        
        <%!
        public String[] generar(String codigo){
            con=CofarConnection.getConnectionJsp();
            String  nombreVentanaHijo="";
            
            System.out.println("k:"+k);
            try{
                Statement st_1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String sql_1="select cod_ventana,nombre_ventana,nodo_padre" +
                        " from ventanas_recursos_humanos" +
                        " where  cod_ventanapadre='"+codigo+"'";
                sql_1+="  order by nombre_ventana asc ";
                System.out.println("sql_1:"+sql_1);
                ResultSet rs_1 = st_1.executeQuery(sql_1);
                codVentanaHijo="";
                nombreVentanaHijo="";
                while(rs_1.next()){
                    System.out.println("entro 2");
                    codVentanaHijo=rs_1.getString(1);
                    nombreVentanaHijo=rs_1.getString(2);
                    String nodoPadre=rs_1.getString(3);
                    /*  if (nodoPadre.equals("1")){*/
                    generaArbol[k++]=nodoPadre;
                    generaArbol[k++]=codVentanaHijo;
                    generaArbol[k++]=nombreVentanaHijo;
                    generar(codVentanaHijo);
                    
                    System.out.println("hijo------------:"+nombreVentanaHijo);
                    // }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
            
            return  generaArbol;
        }
        %>  
        <%!
        public String[] generarCompras(String codigo){
            con=CofarConnection.getConnectionJsp();
            String  nombreVentanaHijo="";
            
            System.out.println("k:"+k);
            try{
                Statement st_1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                Statement st_2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String sql_1="select codigomenubloque,nombrebloque" ;
                sql_1+=" from bloquesmenu_compras" ;
                sql_1+=" order by orden asc ";
                System.out.println("sql_1:"+sql_1);
                ResultSet rs_1 = st_1.executeQuery(sql_1);
                while(rs_1.next()){
                    String codBloque=rs_1.getString(1);
                    String nombreBloque=rs_1.getString(2);
                    String sql_2="select codigo_ventana,nombre_ventana,codigo_bloque" ;
                    sql_2+=" from ventanas_compras" ;
                    sql_2+=" where codigo_bloque='"+codBloque+"'" ;
                    sql_2+=" order by nombre_ventana asc ";
                    System.out.println("sql_2:"+sql_2);
                    ResultSet rs_2 = st_2.executeQuery(sql_2);
                    codVentanaHijo="";
                    nombreVentanaHijo="";
                    generaArbol[k++]="0";
                    generaArbol[k++]="0";
                    generaArbol[k++]=nombreBloque;
                    while(rs_2.next()){
                        System.out.println("entro 2");
                        codVentanaHijo=rs_2.getString(1);
                        nombreVentanaHijo=rs_2.getString(2);
                        generaArbol[k++]=codBloque;
                        generaArbol[k++]=codVentanaHijo;
                        generaArbol[k++]=nombreVentanaHijo;
                        System.out.println("codVentanaHijo------------:"+codVentanaHijo);
                        System.out.println("nombreVentanaHijo------------:"+nombreVentanaHijo);
                        //generarCompras(codBloque);
                        
                        // }
                    }
                }
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
            
            return  generaArbol;
        }
        %>  
        <br><br>
        <h3 align="center">Modificar Usuario</h3>
        
        <form method="post" action="guardar_modificar_usuarios.jsp" name="upform"  id="upform">
            <div align="center">
                <table border="0" style="border:solid #cccccc 1px"  class="outputText2" align="center" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Introduzca Datos
                            </div>    
                        </td>
                        
                    </tr>
                    <%
                    codigo="";
                    codigo=request.getParameter("codigo");
                    String codModulo=request.getParameter("cod_modulo");
                    try{
                        
                        System.out.println("codModulo:.........."+codModulo);
                        String sql_aux=" select p.ap_paterno_personal,p.ap_materno_personal,p.nombres_personal," +
                                " um.nombre_usuario,um.contrasena_usuario" +
                                " from usuarios_modulos um,personal p"+
                                " where um.cod_personal=p.cod_personal and p.cod_personal='"+codigo+"'" +
                                " and um.cod_modulo='"+codModulo+"'";
                        
                        System.out.println("sql_aux:.........."+sql_aux);
                        Statement st_aux = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_aux = st_aux.executeQuery(sql_aux);
                        String paterno="";
                        while (rs_aux.next()){
                            paterno=rs_aux.getString("ap_paterno_personal");
                            String materno=rs_aux.getString("ap_materno_personal");
                            String nombres=rs_aux.getString("nombres_personal");
                            String nombreUsuario=rs_aux.getString("nombre_usuario");
                            String contrasenaUsuario=rs_aux.getString("contrasena_usuario");
                    
                    %>
                    <tr>
                        <td>Nombre</td>
                        <td>::</td>
                        <td >
                            <input name="persona" disabled="true" value="<%=paterno%> <%=materno%> <%=nombres%>" type=text class="inputText" size="35" style='text-transform:uppercase;'>
                        </td>
                    </tr>
                    <tr>
                        <td>Usuario</td>
                        <td>::</td>
                        <td >
                            <input name="usuario" value="<%=nombreUsuario%>" type=text class="inputText" size="35" >
                        </td>
                    </tr>
                    <tr>
                        <td>Contraseña</td>
                        <td>::</td>
                        <td >
                            <input name="contrasena" value="<%=contrasenaUsuario%>" type=text class="inputText" size="35"  >
                        </td>
                    </tr> 
                    
                    <input type="hidden" value="<%=codigo%>" name="personal">
                    <%  
                        }
                    } catch(Exception e) {
                    }  
                    %>
                </table>
                <table style="border: solid #cccccc 1px"   class="outputText2" align="center" width="55%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Opciones del Sistema
                            </div>    
                        </td>
                    </tr>
                    <tr>
                        <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        
                        <td class=colh align="center" style="border : solid #f2f2f2 1px;"></td>
                    </tr>
                    
                    
                    <%
                    try{
                        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        Statement st_1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        String sql="select count(codigo_ventana)as nro_ventanas" +
                                " from ventanas_compras" ;
                        
                        System.out.println("sql**************:"+sql);
                        ResultSet rs = st.executeQuery(sql);
                        String count="";
                        while(rs.next()){
                            count=rs.getString(1);
                            int contador=Integer.parseInt(count);
                            contador=(contador+6)*3;
                            String inicial="0";
                            k=0;
                            String aux[]=generarCompras(inicial);
                            System.out.println("aux[100000000000000000000]:"+aux[2]);
                            for(int j=0;j<contador;j++){
                                System.out.println("aux["+j+"]:"+aux[j]);
                            }
                            for(int i=0;i<contador;i=i+3){
                                System.out.println("123456789");
                                if(aux[i]!=null){
                                    System.out.println("456789");
                                    if(aux[i].equals("0")){
                                        System.out.println("aaaaaaaaaa");
                    
                    %>
                    <tr>
                        <%--td bgcolor="#123456" style="border : solid #f2f2f2 1px;"><%=aux[i]%></td--%>
                        <td bgcolor="#f2f2f2" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td  bgcolor="#f2f2f2" style="border : solid #f2f2f2 1px;"><b > <%=aux[i+2]%></b></td>
                    </tr>
                    <%
                    
                    
                                    }else{
                                        String sql_3="select codigo_ventana" +
                                                " from usuarios_accesos_modulos where cod_modulo='"+codModulo+"'" +
                                                " and cod_personal='"+codigo+"' and codigo_ventana='"+aux[i+1]+"'" ;
                                        
                                        System.out.println("sql_3:"+sql_3);
                                        ResultSet rs_3 = st.executeQuery(sql_3);
                                        int sw=0;
                                        while(rs_3.next()){
                                            sw=1;
                                        }
                                        if (sw==1){
                    %>
                    <tr>
                        <%--td bgcolor="#123456" style="border : solid #f2f2f2 1px;"><%=aux[i]%></td--%>
                        <td style="border : solid #f2f2f2 1px;"><input type="checkbox" checked="true" name="codigo" value="<%=aux[i+1]%>" ></td>
                        <td class=colh style="border : solid #f2f2f2 1px;"> <%=aux[i+2]%></td>
                    </tr>
                    <%
                                        }else{
                    %>
                    <tr>
                        <%--td bgcolor="#123456" style="border : solid #f2f2f2 1px;"><%=aux[i]%></td--%>
                        <td style="border : solid #f2f2f2 1px;"><input type="checkbox" name="codigo" value="<%=aux[i+1]%>" ></td>
                        <td class=colh style="border : solid #f2f2f2 1px;"> <%=aux[i+2]%></td>
                    </tr>
                    <%
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                    } catch(Exception e) {
                    }               
                    %>  
                    
                    
                </table>
                <input type="hidden" value="<%=codModulo%>" name="cod_modulo">
            </div>
            <br>
            
            <center>
                <input type="hidden" id="codigo" name="codigo">     
                <input type="button"   class="btn" size="35" value="Guardar" name="reporte" onclick=" editar(this.form);">
                <input type="button"   class="btn"  size="35" value="Cancelar" name="limpiar" onclick="cancelar();">
            </center>
        </form>
        
    </body>
</html>