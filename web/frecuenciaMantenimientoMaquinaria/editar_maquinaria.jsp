package frecuenciaMantenimientoMaquinaria;

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script src="../js/general.js"></script>
            <script>
               function validar(){
                   var compronenteProd=document.getElementById('form1:compronenteProd');                  
                   if(compronenteProd.value==''){
                     alert('Por favor Seleccione un producto para su formula maestra.');
                     compronenteProd.focus();
                     return false;
                   }                   
                   return true;
                }
                           function Material(input,f){
               //alert(input.name);
               var elements=document.getElementById(f);                  
               for(var i=0;i<=elements.length-1;i++){
                  //alert(elements[i].value);
                  //var cellsElement=rowsElement[i].cells;
                  //var cel=elements[i];
                  if (elements[i].name==input.name){
                     alert(input.name);
                     if (elements[i].checked==true){
                       alert("entrooo"+elements[i+1].value);
                       elements[i+1].disabled=false;
                     }
                     else{
                       
                       /*alert("Seleccione el Personal antes de asignar el Monto.");
                       elements[i].value='';
                       event.returnValue = false;*/
                     }
                  }                      
               }  
              
           }           
            </script>
        </head>
        <body>
            <h:form id="form1"  >
                
                <div align="center">
                    <h:outputText styleClass="outputTextTitulo"  value="Registrar Máquina" />                    
                    
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca Datos" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>      
                        
                        <h:outputText styleClass="outputText2" value="Código - Area"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedMaquinaria.maquinariabean.codigo}" id="codigo"  />

                        <h:outputText value="Area " styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedMaquinaria.maquinariabean.codAreaMaquina}" >
                            <f:selectItems value="#{ManagedMaquinaria.areasMaquinaList}"  />
                        </h:selectOneMenu>

                        <h:outputText styleClass="outputText2" value="Máquina"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedMaquinaria.maquinariabean.nombreMaquina}" id="maquina"  />
                        
                        <h:outputText  styleClass="outputText2" value="Fecha de Compra"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:panelGroup>
                            <h:inputText styleClass="outputText2" value="#{ManagedMaquinaria.maquinariabean.fechaCompra}"  id="f_inicio" />
                            <h:graphicImage url="../img/fecha.bmp"  id="imagenFinicio" />
                            <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:f_inicio\" click_element_id=\"form1:imagenFinicio\"></DLCALENDAR>"  escape="false"  />
                        </h:panelGroup>  
                        
                        <h:outputText value="Tipo de Maquinaria" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedMaquinaria.maquinariabean.tiposEquiposMaquinaria.codTipoEquipo}" >
                            <f:selectItems value="#{ManagedMaquinaria.tiposEquipoList}"  />
                        </h:selectOneMenu>    
                        
                        <h:outputText value="GMP" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedMaquinaria.maquinariabean.GMP}" >
                            <f:selectItems value="#{ManagedMaquinaria.GMPList}"  />
                        </h:selectOneMenu>   
                        
                        <h:outputText value="Descripción" styleClass="outputText2"  />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                    <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedMaquinaria.maquinariabean.obsMaquina}" id="obs"   />
                        
                        <h:outputText value="Estado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedMaquinaria.maquinariabean.estadoReferencial.codEstadoRegistro}" >
                            <f:selectItems value="#{ManagedMaquinaria.estadoRegistro}"  />
                        </h:selectOneMenu> 
                        
                        
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Guardar" styleClass="btn"  action="#{ManagedMaquinaria.modificarMaquinarias}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedMaquinaria.Cancelar}"/>
                    
                </div>
                
                
            </h:form>
            <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
    </html>
    
</f:view>

