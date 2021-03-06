//
//  Ticket.h
//  AirTicketClient
//
//  Created by Дмитрий Федоринов on 28.04.2018.
//  Copyright © 2018 Geekbrains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteTicket+CoreDataClass.h"
@interface Ticket : NSObject

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *airline;
@property (nonatomic, strong) NSDate *departure;
@property (nonatomic, strong) NSDate *expires;
@property (nonatomic, strong) NSNumber *flightNumber;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *fromFullName;
@property (nonatomic, strong) NSString *toFullName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(instancetype)initWithFavorite:(FavoriteTicket *)favorite;


@end
