import { ObjectType, Field, Int } from '@nestjs/graphql';
import { User } from './user.model';

@ObjectType()
export class Post {
  @Field(() => Int)
  id: number;

  @Field()
  title: string;

  @Field()
  content: string;

  @Field(() => Int)
  authorId: number;

  @Field(() => User, { nullable: true })
  author?: User;
}
