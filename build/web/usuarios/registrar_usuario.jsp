<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
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
                function registrar(f){
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
                    {	alert('Debe seleccionar almenos un Registro para ser Registrado.');
                    }
                    else
                    {   
                        location.href="guardar_registrar_usuarios.jsf?codigo="+codigo+"&personal="+f.personal.value+"&usuario="+f.usuario.value+"&contrasena="+f.contrasena.value+"&cod_modulo="+f.cod_modulo.value;
                    	//location.href="eliminarAreasempresaLista.do?codigo="+codigo;
                        
                        //alert(codigo);
                    }
                }                
        </script>
    </head>
    <body> 
        
        <%! 
        Connection con=null;
        String codVentanaHijo="";
        String generaArbol[]=new String[1500];
        int k=0;
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
                    
                    generaArbol[k++]=nodoPadre;
                    generaArbol[k++]=codVentanaHijo;
                    generaArbol[k++]=nombreVentanaHijo;
                    
                    generar(codVentanaHijo);
                    
                    System.out.println("hijo------------:"+nombreVentanaHijo);
                    
                }
                rs_1.close();
                st_1.close();
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
                        System.out.println("k------------:"+k);
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
        <h3 align="center">Registro de Usuario</h3>
        
        <form method="post" action="guardar_registrar_usuarios.jsp"  >
            
            <div align="center">
                <table style="border: solid #cccccc 1px"   class="outputText2" align="center" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Introduzca Datos
                            </div>    
                        </td>
                        
                    </tr>
                    <tr>
                        
                        <td class="outputText2">Nombre</td>
                        <td class="outputText2">::</td>
                        <td>
                            <%
                            String codModulo=request.getParameter("cod_modulo");
                            try{
                                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                String sql="select p.cod_personal,p.ap_paterno_personal,p.ap_materno_personal,p.nombres_personal" +
                                        " from personal p" +
                                        " where p.cod_estado_persona=1 and p.cod_personal<>ALL" +
                                        "(select um.cod_personal from usuarios_modulos um where um.cod_modulo='"+codModulo+"')";
                                sql+="  order by ap_paterno_personal asc ";
                                System.out.println("sql:"+sql);
                                ResultSet rs = st.executeQuery(sql);
                            %> 
                            
                            <select name="personal" class="outputText2"> 
                                
                                <%
                                String codPersonal="";
                                String apPaternoPersonal="";
                                String apMaternoPersonal="";
                                String nombrePersonal="";
                                while (rs.next()) {
                                    codPersonal=rs.getString("cod_personal");
                                    apPaternoPersonal=rs.getString("ap_paterno_personal");
                                    apMaternoPersonal=rs.getString("ap_materno_personal");
                                    nombrePersonal=rs.getString("nombres_personal");
                                
                                %>                      <option value="<%=codPersonal%>"><%=apPaternoPersonal%> <%=apMaternoPersonal%> <%=nombrePersonal%></option>				    
                                <%                    }
                                %>
                                
                            </select>
                            <%
                            
                            } catch(Exception e) {
                            }               
                            %>  
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="outputText2">Usuario</td>
                        <td class="outputText2">::</td>
                        <td >
                            <input name=usuario type=text class="inputText" size="40" >
                        </td>
                    </tr>
                    <tr>
                        <td class="outputText2">Contraseña</td>
                        <td class="outputText2">::</td>
                        <td >
                            <input name=contrasena type=text class="inputText" size="40">
                        </td>
                    </tr> 
                </table>
                <table style="border: solid #cccccc 1px"   class="outputText2" align="center" width="50%">
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
                        
                        System.out.println("sql:"+sql);
                        ResultSet rs = st.executeQuery(sql);
                        String count="";
                        while(rs.next()){
                            count=rs.getString(1);
                            int contador=Integer.parseInt(count);
                            contador=(contador+6)*3;
                            String inicial="0";
                            k=0;
                            String aux[]=generarCompras(inicial);
                            System.out.println("pasoooooooooooooooooo");
                            System.out.println("aux[100000000000000000000]:"+aux.length);
                            for(int i=0;i<contador;i=i+3){
                                System.out.println("aux[i]:"+aux[i]);
                                if(aux[i]!=null){
                                    if(aux[i].equals("0")){
                    %>
                    <tr>
                        <%--td bgcolor="#123456" style="border : solid #f2f2f2 1px;"><%=aux[i]%></td--%>
                        <td bgcolor="#f2f2f2" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td  bgcolor="#f2f2f2" style="border : solid #f2f2f2 1px;"><b ><%=aux[i+2]%></b></td>
                    </tr>
                    <%
                                    }else{
                    %>
                    <tr>
                        <%--td bgcolor="#123456" style="border : solid #f2f2f2 1px;"><%=aux[i]%></td--%>
                        <td style="border : solid #f2f2f2 1px;"><input type="checkbox" name="codigo" value="<%=aux[i+1]%>" ></td>
                        <td class=colh style="border : solid #f2f2f2 1px;"><%=aux[i+2]%></td>
                    </tr>
                    <%
                                    }
                                    
                                }
                            }
                        }
                        
                    } catch(SQLException e) {
                        e.printStackTrace();
                    }               
                    %>  
                    
                    
                </table>
                <input type="hidden" value="<%=codModulo%>" name="cod_modulo">
            </div>
            <br>
            <center>
                <input type="button"   class="btn" size="35" value="Guardar" name="reporte" onclick="registrar(this.form);">
                <input type="button"   class="btn"  size="35" value="Cancelar" name="limpiar" onclick="cancelar();">
            </center>
        </form>
        
    </body>
</html>