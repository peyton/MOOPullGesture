//
//  HipsterIpsumGenerator.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/22/12.
//  Copyright (c) 2012 pandolph. All rights reserved.
//

#import "HipsterIpsumGenerator.h"


static NSString * const hipsterIpsum = @"PBR truffaut craft beer put a bird on it, vice next level portland quinoa DIY sriracha before they sold out forage chillwave bicycle rights mumblecore. Synth kogi direct trade occupy skateboard, vinyl irony hella pinterest. Mixtape banh mi semiotics craft beer fixie fingerstache. Selvage pour-over lomo master cleanse 3 wolf moon, synth messenger bag typewriter retro. Austin tofu fap umami truffaut fanny pack. Biodiesel readymade brooklyn brunch marfa jean shorts craft beer, synth semiotics. Blog fap truffaut hella. Stumptown brunch echo park pitchfork pork belly williamsburg. Gentrify quinoa tofu readymade cardigan food truck. Before they sold out messenger bag PBR, wes anderson synth seitan single-origin coffee occupy. Skateboard artisan bushwick, tumblr tattooed leggings vice. Marfa pop-up single-origin coffee aesthetic photo booth quinoa, leggings mlkshk 3 wolf moon art party carles. Terry richardson semiotics single-origin coffee, aesthetic sriracha cred messenger bag helvetica salvia irony portland fap odd future synth. DIY sartorial mumblecore stumptown retro wayfarers, viral gentrify. Letterpress bicycle rights kogi shoreditch, before they sold out terry richardson cardigan sustainable echo park gluten-free portland cosby sweater bushwick. Keytar scenester food truck farm-to-table carles. Leggings carles four loko locavore american apparel tattooed twee bespoke before they sold out sustainable high life, brooklyn butcher fanny pack. Pitchfork you probably haven't heard of them truffaut, master cleanse bushwick four loko gastropub +1 quinoa direct trade chambray. Pork belly fingerstache terry richardson tattooed gastropub dreamcatcher before they sold out brooklyn butcher. Vice semiotics direct trade, art party bushwick high life shoreditch thundercats street art artisan trust fund hella Austin locavore yr. Vinyl narwhal readymade organic typewriter. Next level chambray salvia, master cleanse PBR whatever fanny pack small batch fixie photo booth tattooed odd future. Pop-up seitan carles keffiyeh. Swag bespoke etsy, shoreditch wolf wes anderson DIY tofu dreamcatcher cosby sweater williamsburg pour-over skateboard mlkshk pinterest. Hoodie truffaut master cleanse 3 wolf moon, keffiyeh pinterest typewriter. Tofu truffaut wolf blog flexitarian biodiesel kale chips mumblecore cred, high life cray +1. Bushwick single-origin coffee wayfarers polaroid. Marfa jean shorts +1, wolf godard ethnic banksy odd future selvage. VHS synth helvetica, irony cardigan vice hoodie salvia wolf brunch before they sold out lo-fi. Chambray etsy carles, ennui letterpress art party cray artisan banksy pour-over. Butcher irony small batch, keytar put a bird on it fanny pack mixtape locavore banh mi. Ethnic tattooed post-ironic you probably haven't heard of them. Kale chips DIY irony mustache, wayfarers umami cred fanny pack lo-fi. Keffiyeh next level direct trade, flexitarian kale chips wes anderson VHS butcher trust fund squid tofu synth skateboard. Occupy iphone whatever gentrify keffiyeh craft beer. Squid craft beer tofu, gentrify you probably haven't heard of them DIY farm-to-table mcsweeney's. Mlkshk typewriter twee, american apparel +1 before they sold out pour-over tofu dreamcatcher bespoke shoreditch sriracha pinterest ethnic organic. Fixie yr blog messenger bag pinterest, keffiyeh +1 marfa scenester kale chips aesthetic high life food truck. Shoreditch Austin jean shorts iphone readymade, gentrify bushwick organic marfa. Sustainable freegan fixie, terry richardson quinoa raw denim jean shorts mumblecore tofu gastropub street art american apparel hella mcsweeney's. Fanny pack quinoa artisan blog skateboard. Marfa whatever tattooed, keytar chillwave kale chips butcher forage helvetica godard. Portland craft beer Austin truffaut, twee pork belly mcsweeney's yr letterpress quinoa. Quinoa helvetica post-ironic, bicycle rights vinyl photo booth 8-bit hoodie hella scenester squid readymade thundercats vice. Art party tattooed you probably haven't heard of them quinoa. Pour-over wes anderson single-origin coffee, blog ennui farm-to-table kogi portland. Vinyl bushwick post-ironic, pinterest narwhal gentrify gastropub DIY umami artisan. Readymade next level messenger bag, helvetica mixtape narwhal swag cardigan ennui. Readymade Austin craft beer, mixtape yr +1 sriracha wes anderson mcsweeney's swag pop-up lomo seitan locavore hoodie. Terry richardson keffiyeh salvia polaroid sriracha PBR, butcher mcsweeney's bicycle rights you probably haven't heard of them food truck lomo blog jean shorts. Kogi ennui brooklyn, messenger bag marfa ethnic scenester wayfarers typewriter pinterest salvia tofu gentrify yr. Odd future cardigan gluten-free, art party synth portland echo park flexitarian terry richardson sustainable vice narwhal selvage. Fixie forage +1 shoreditch. Tofu mlkshk authentic swag american apparel, forage art party echo park artisan banh mi marfa chambray trust fund. Cred freegan PBR polaroid, lo-fi scenester odd future sustainable ethnic cosby sweater mixtape organic selvage post-ironic shoreditch. Readymade sustainable thundercats DIY pour-over 3 wolf moon, aesthetic mumblecore vinyl dreamcatcher pork belly squid forage echo park marfa.";

static NSArray *words;

@implementation HipsterIpsumGenerator

+ (void)initialize;
{
    NSString *wordsWithoutPeriods = [hipsterIpsum stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *wordsWithoutCommas = [wordsWithoutPeriods stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    words = [[wordsWithoutCommas lowercaseString] componentsSeparatedByString:@" "];
}

+ (NSString *)phraseOfLength:(NSUInteger)length;
{
    if (length == 0)
        return nil;
    
    NSMutableArray *randomWords = [NSMutableArray array];
    for (NSUInteger i = 0; i < length; i++)
        [randomWords addObject:[words objectAtIndex:arc4random() % [words count]]];
    
    NSString *joinedString = [randomWords componentsJoinedByString:@" "];
    NSString *capitalizedString = [joinedString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[joinedString substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"%@.", capitalizedString];
}

@end
