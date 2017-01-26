//
//  GLViewController.swift
//  ColoredSquare
//
//  Created by burt on 2016. 2. 26..
//  Copyright © 2016년 BurtK. All rights reserved.
//
import UIKit
import GLKit

class GLKUpdater : NSObject, GLKViewControllerDelegate {
    
    weak var glkViewController : GLViewController!
    
    init(glkViewController : GLKViewController) {
        self.glkViewController = glkViewController as! GLViewController
        self.glkViewController.startTime = Double(NSDate.timeIntervalSinceReferenceDate)
    }
    
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        glkViewController.globalTime = Double(NSDate.timeIntervalSinceReferenceDate) - glkViewController.startTime
    }
}


class GLViewController: GLKViewController {
    
    var glkView: GLKView!
    var glkUpdater: GLKUpdater!
    
    var vertexBuffer : GLuint = 0
    var indexBuffer: GLuint = 0
    var shader : BaseEffect!
    
    let vertices : [Vertex] = [
        Vertex( 1.0, -1.0, 0, 1.0, 0.0, 0.0, 1.0),
        Vertex( 1.0,  1.0, 0, 0.0, 1.0, 0.0, 1.0),
        Vertex(-1.0,  1.0, 0, 0.0, 0.0, 1.0, 1.0),
        Vertex(-1.0, -1.0, 0, 1.0, 1.0, 0.0, 1.0)
    ]
    
    let indices : [GLubyte] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    var globalTimeUniform: GLint = 0
    var resXUniform: GLint = 0
    var resYUniform: GLint = 0
    
    var startTime: Double = 0.0
    var globalTime: Double = 0.0
    var resX = UIScreen.main.bounds.width
    var resY = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGLcontext()
        setupGLupdater()
        setupShader()
        setupVertexBuffer()
        setUpUniform()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        // shader.begin() 이 더 나은거 같다.
        shader.prepareToDraw()
        
        glUniform1f(globalTimeUniform, GLfloat(globalTime));
        glUniform1f(resXUniform, GLfloat(resX));
        glUniform1f(resYUniform, GLfloat(resY));
        
        glEnableVertexAttribArray(VertexAttributes.Position.rawValue)
        glVertexAttribPointer(
            VertexAttributes.Position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size),BUFFER_OFFSET(0))
        
        
        glEnableVertexAttribArray(VertexAttributes.Color.rawValue)
        glVertexAttribPointer(
            VertexAttributes.Color.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(3 * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a :: offset is 3*sizeof(GLfloat)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        
        glDisableVertexAttribArray(VertexAttributes.Position.rawValue)
    }
}

extension GLViewController {
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(glkView.context)
    }
    
    func setupGLupdater() {
        self.glkUpdater = GLKUpdater(glkViewController: self)
        self.delegate = self.glkUpdater
    }
    
    func setupShader() {
        self.shader = BaseEffect(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "CristalVoronoiFragmentShader.glsl")
    }
    
    func setupVertexBuffer() {
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        let count = vertices.count
        let size =  MemoryLayout<Vertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, vertices, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(GLsizei(1), &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count * MemoryLayout<GLubyte>.size, indices, GLenum(GL_STATIC_DRAW))
    }
    
    func setUpUniform() {
        globalTimeUniform = glGetUniformLocation(shader.programHandle, "globalTime");
        resXUniform = glGetUniformLocation(shader.programHandle, "resX");
        resYUniform = glGetUniformLocation(shader.programHandle, "resY");
    }
    
    func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: i)
    }
}


extension GLViewController {
    
    // MARK: Actions
    @IBAction func play(_ sender: MenuButton) {
        startPlayViewController(3, 3)
    }
    
    @IBAction func pixels(_ sender: MenuButton) {
        startPlayViewController(4, 5)
    }
    
    @IBAction func settings(_ sender: MenuButton) {
        startPlayViewController(5, 7)
    }
    
    func startPlayViewController(_ itemPerLine: Int, _ line:Int) {
        let storyboard = UIStoryboard(name: "PlayStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
        controller.gameEngine.itemPerLine = itemPerLine
        controller.gameEngine.line = line
        self.present(controller, animated: true, completion: nil)
    }
}
