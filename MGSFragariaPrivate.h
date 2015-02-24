//
//  MGSFragariaPrivate.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 24/02/15.
//
//

// class extension
@interface MGSFragaria()

@property (nonatomic, readwrite) MGSExtraInterfaceController *extraInterfaceController;
@property (nonatomic, strong, readwrite) MGSSyntaxErrorController *syntaxErrorController;

@property (nonatomic,strong) NSSet* objectGetterKeys;
@property (nonatomic,strong) NSSet* objectSetterKeys;

- (void)updateGutterView;

@end

