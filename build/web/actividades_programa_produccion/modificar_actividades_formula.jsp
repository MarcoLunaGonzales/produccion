<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
    <script type="text/javascript" src="../js/general.js"></script>
    <script>
                function validar(){
                   var nombre=document.getElementById('form1:nombre');
                   var alto=document.getElementById('form1:alto');
                   var largo=document.getElementById('form1:largo');
                   var ancho=document.getElementById('form1:ancho');
                   var peso=document.getElementById('form1:peso');
                   
                
                   if(nombre.value==''){
                     alert('El Campo Cartón Corrugado esta vacío.');
                     nombre.focus();
                     return false;
                   }
                   if(alto.value==''){
                     alert('El Campo Dimensión Alto esta vacío.');
                     alto.focus();
                     return false;
                   }
                   if(largo.value==''){
                     alert('El Campo Dimensión Largo esta vacío.');
                     largo.focus();
                     return false;
                   }
                   if(ancho.value==''){
                     alert('El Campo Dimensión Ancho esta vacío.');
                     ancho.focus();
                     return false;
                   }
                   if(peso.value==''){
                     alert('El Campo Peso Gramos esta vacío.');
                     peso.focus();
                     return false;
                   }
                
                                   
                   return true;
                }
    </script>
</head>
<body>

<h:form id="form1"  >                
<div align="center">
    <br>
    <h:outputText value="Editar Proceso de Producción por Fórmula Maestra" styleClass="tituloCabezera1"    />
    <br> <br> <b></b> <h:outputText value="#{ManagedActividadesFormulaMaestra.nombreComProd}"   /></b> 
    <br><br>
    <rich:dataTable value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraEditarList}" var="data" id="dataCadenaCliente" 
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo"
    >
        <h:column>
            <f:facet name="header">
                <h:outputText value=""  />
                
            </f:facet>
            <h:selectBooleanCheckbox value="#{data.checked}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Orden"  />
            </f:facet>
            <h:inputText value="#{data.ordenActividad}" styleClass="inputText" onkeypress="valNum();" size="10"/>
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Actividades Producción"  />
            </f:facet>
            <h:outputText value="#{data.actividadesProduccion.nombreActividad}" styleClass="" />
        </h:column>

    </rich:dataTable>
    <br>
    <h:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedActividadesFormulaMaestra.modificarActividadesFormulaMaestra}"   onclick="return validar();" />
    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedActividadesFormulaMaestra.Cancelar}"/>
</div>                                
</h:form>
</body>
</html>

</f:view>

