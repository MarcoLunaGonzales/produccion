
<%@page import="javax.faces.context.FacesContext" %>
<%@page import="javax.servlet.ServletContext" %>
<%@page import="javax.servlet.http.HttpSession" %>
<%@page import="javax.faces.context.ExternalContext" %>
<%@page import="javax.servlet.http.*" %>
<%@page import="java.io.IOException" %>

  <html>
        <head>
          
           
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="css/ventas.css" />
            <script type="text/javascript" src="js/general.js" ></script>
            <style>
                .on:click
                {
                    color:red;
                }
                .on{
                    font-size:12px;
                    color:blue;
                    border-bottom:1px solid blue;
                }
            </style>
        </head>
            <body>

                <form>
                    <center>
                       <table style="margin-top:25px; z-index:30">
                        <tr>
                            <td align="center">
                     <span class="outputText2">Termino su sesion</span>
                     </td>
                     </tr>
 <tr>
     <td align="center">
     <a href="../login.jsf" class="on" onmouseover="this.cursor='hand'; " ><span >Iniciar Sesion</span></a>
     </td>
     </tr>
    </table>
    </center>
        <div align="center" style="z-index:2; position:absolute; filter:alpha(opacity=50); opacity:0.5;width:100%;height:100%;background-position:center; background-attachment:fixed;background-repeat:no-repeat;background-image:url('img/mainBiblioteca.jpg')">
                
        </div>
                            <%
            try
                    {
                   HttpSession session1= (HttpSession)FacesContext.getCurrentInstance().getExternalContext().getSession(false);
                   session1.invalidate();
                   
    
                   }
            catch(Exception e)
                    {
                e.printStackTrace();
            
            }
            
            %>
            <script>
             window.location.href='login.jsf';
                        </script>
</form>
</body>
