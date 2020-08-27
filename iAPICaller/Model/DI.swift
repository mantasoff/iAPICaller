import Swinject

public class DI {
    private static var synchronizedResolver: Resolver?
    private static var assembler: Assembler?
    
    public class func initialize(assemblies: [Assembly]) {
        assembler = Assembler(assemblies)
  }
  
  private class func getSynchronizedResolver() -> Resolver {
      guard let assembler = self.assembler else {
          fatalError("DI: Assembler not initialized")
      }
      
      guard let synchronizedResolver = self.synchronizedResolver else {
          self.synchronizedResolver = (assembler.resolver as! Container).synchronize() // swiftlint:disable:this force_cast
          return getSynchronizedResolver()
      }
      
      return synchronizedResolver
  }
  
  public class func applyAssembly(_ assembly: Assembly) {
    DI.assembler?.apply(assembly: assembly)
  }
  
    public class func resolve<Service>(_ serviceType: Service.Type) -> Service {
        getSynchronizedResolver().resolve(serviceType)!
    }
    
    public class func resolve<Service>(_ serviceType: Service.Type, name: String) -> Service {
        getSynchronizedResolver().resolve(serviceType, name: name)!
    }
}
