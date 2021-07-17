
## Concept

### User interface and user interaction design

One of the main objectives is to design user interactions scenarios. It is a kind of brainstorming where different ideas can find their places on a canvas. The list of requirements helps to find an appropriate layout design and provide a well-suited functionality.

![Sketch: user interface and user experience design](images/ui_ux_sketch.png) 

As we see on the sketch above. There are two main views. 

* **Navigation view** represents the barcode information to the user. 
* **Camera view** is a scanner view to capture and scan the barcodes.

The list of the features aims to provide a seamless and pleasant user experience.

## Architecture requirements

The application can be divided into three interconnected parts namely the model, the view, and the controller. All of these components are designed to handle some specific logical aspects of the application. [2]

Since there is no need for a heavy controller, the Model-View-ViewModel (MVVM) was chosen as an architecture pattern for the application.

It can be useful to define the main parts of the pattern. [3]

| Part name | Function |
|:--|:--|
| Model | Store data |
| View | Display data |
| ViewModel | Create, update, delete data |

According to the data persistence requirement, the data should be stored in a database. It can't be lost, if the app was closed.

Using a native CoreData framework, the data persistence requirement can be satisfied.

## Functional requirements

There are several frameworks can be used to implement a barcode scanning solution using the camera on a smartphone. All of them offer a wide range of functionality that satisfies the functional requirements.

The scanning system in this project was implemented with CarBode framework. The framework has a simple API with a configurable functionality. The framework can be easily integrated and is well documented.

The scanning solution should be able to scan 1D and 2D barcodes. This option can be configurable. Using Regex it should differentiate between types of barcode information and use it according to its function. For example, if it is a link, the user can open it.