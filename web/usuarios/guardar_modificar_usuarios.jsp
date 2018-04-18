<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>




<%! Connection con=null;
String codPersonal="";
String [] arraydecodigos= new String[200];

%>
<%

%>
<%
String codModulo=request.getParameter("cod_modulo");
System.out.println("codModulo:"+codModulo);
try{
    System.out.println("entro");
/*for(int m=0;m<199;m++) {
arraydecodigos[m]="";
    }*/
    System.out.println("entro 1");
    String codigo="";
    String aux="";
    
    codigo = request.getParameter("codigo");
    System.out.println("codigo:"+codigo);
    arraydecodigos=codigo.split(",");
    String personal=request.getParameter("personal");
    System.out.println("personal:"+personal);
    String usuario=request.getParameter("usuario");
    System.out.println("usuario:"+usuario);
    String contrasena=request.getParameter("contrasena");
    System.out.println("contrasena:"+contrasena);
    con=CofarConnection.getConnectionJsp();
    Statement stm= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    Statement stm1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    Statement stm2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    Statement stm3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    System.out.println("max_1");
    String sql_eliminar=" delete from USUARIOS_ACCESOS_MODULOS ";
    sql_eliminar+=" where  cod_personal='"+personal+"'";
    sql_eliminar+=" and cod_modulo='"+codModulo+"'";
    System.out.println("sql_eliminar:"+sql_eliminar);
    stm1.executeUpdate(sql_eliminar);
    for(int i=0;i<=arraydecodigos.length-1;i++){
        try{
            System.out.println("arraydecodigos:"+arraydecodigos[i]);
            
            String sql_1="insert into usuarios_accesos_modulos(";
            sql_1+="cod_personal,cod_modulo,codigo_ventana,codigo_estado_ventana) values(";
            
            sql_1+="'"+personal+"',";
            System.out.println("max_2");
            sql_1+="'"+codModulo+"',";
            sql_1+="'"+arraydecodigos[i]+"',";
            sql_1+="1)";
            System.out.println("Insertar usuario acceso m,odulos"+sql_1);
            int rs2=stm.executeUpdate(sql_1);
        } catch(Exception e) {
        }
    }
    String sql="update usuarios_modulos set";
    sql+=" nombre_usuario='"+usuario+"'," +
            " contrasena_usuario='"+contrasena+"'" +
            " where cod_personal='"+personal+"' and cod_modulo='"+codModulo+"'";
    
    System.out.println("update usuario"+sql);
    int rs1=stm.executeUpdate(sql);
    if(rs1>0){
        
    }
    
} catch(Exception e) {
}

%>
<script>
 
                   location='../usuarios/navegador_usuarios.jsf?codigo=1';
</script>

