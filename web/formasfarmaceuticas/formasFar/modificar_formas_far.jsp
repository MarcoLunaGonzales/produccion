<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script>
                function validar(){
                   var abreviatura=document.getElementById('form1:abreviatura');
                   var forma=document.getElementById('form1:forma');
                 
                   if(forma.value==''){
                     alert('El Campo Forma Farmacéutica esta vacío.');
                     forma.focus();
                     return false;
                   }
                     if(abreviatura.value==''){
                     alert('El Campo Abreviatura esta vacío.');
                     abreviatura.focus();
                     return false;
                   }
                   return true;
                }
            </script>
        </head>
        <body>
            <br><br>
            <h:form id="form1"  >                
                <div align="center">
                    <h:outputText value="Editar Forma Farmaceútica" styleClass="tituloCabezera1"    />
                    <br><br>
                    <table  class="table2"  >
                        <tr class="headerClassACliente">
                            <td  colspan="3" ><div style="text-align:center">
                                    <h:outputText value="Introduzca Datos" styleClass="tituloCabezera"    />
                                </div>            
                            </td>
                        </tr> 
                        <tr>
                            <td><h:outputText value="Forma Farmaceútica" styleClass="outputText2"/></td>   
                            <td><h:outputText value="::" styleClass="outputText2"/></td>   
                            <td><h:inputText  styleClass="inputText" onkeypress="valMAY();"  size="50"  value="#{ManagedFormasFar.formasFarbean.nombreForma}" id="forma"/></td>
                        </tr>
                        <tr>
                            <td><h:outputText value="Abreviatura" styleClass="outputText2"/></td>   
                            <td><h:outputText value="::" styleClass="outputText2"/></td>   
                            <td><h:inputText  styleClass="inputText" onkeypress="valMAY();"  size="50"  value="#{ManagedFormasFar.formasFarbean.abreviaturaForma}" id="abreviatura"/></td>
                        </tr>
                        <tr>
                            <td><h:outputText value="Estado" styleClass="outputText2"   /> </td>                                               
                            <td><h:outputText  styleClass="outputText2" value="::"/> </td>                               
                            <td><h:selectOneMenu styleClass="inputText" value="#{ManagedFormasFar.formasFarbean.estadoReferencial.codEstadoRegistro}" >
                                <f:selectItems value="#{ManagedFormasFar.estadoRegistro}"  />
                        </h:selectOneMenu>   </td>  
                    </tr>                            
                    </table>   
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton"  action="#{ManagedFormasFar.modificarFormasFar}" onclick="return validar();" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedFormasFar.Cancelar}" />
                    
                </div>                
            </h:form>
        </body>
    </html>
    
</f:view>

