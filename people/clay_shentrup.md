# Clay Notes

* use Rubocop for consistency of code style

* use a CI system to help maintain quality of test suite
  * checkout: Circle CI, Jenkins, Semaphore

* ActiveModel Callbacks are bad (use a service object to handle this kind of logic) search the practical object oriented design book for kind_of?
* instead of send, use public_send, you really shouldn't be sending to a private method
* protected doesn't work the way you think it works (look it up)
* check out Kanban process: http://www.amazon.com/Lean-Trenches-Managing-Large-Scale-Projects/dp/1934356859/ref=sr_1_5?ie=UTF8&qid=1373664970&sr=8-5&keywords=kanban

* heisen bug (the craziest fucking bug I've ever seen - Yahuda)

* check out bundle standalone (Myron Marston)

* using Rails.env is an anti pattern

* git bisect
  http://git-scm.com/book/en/Git-Tools-Debugging-with-Git
  http://code-worrier.com/blog/git-bisect-basics/

* http://www.youtube.com/watch?v=ZDR433b0HJY&noredirect=1
* http://paulhammant.com/blog/branch_by_abstraction.html/

* YAGNI http://en.wikipedia.org/wiki/You_aren't_gonna_need_it

* checkout estimation is evil article: http://pragprog.com/magazines/2013-02/estimation-is-evil

* git annotate

* paste without formatting: shift + command + v

* tell which private key to use for SSH
  http://superuser.com/questions/232373/tell-git-which-private-key-to-use

* "needing to seed data in a migration is maybe a sign that the data you are trying to seed doesn't belong in the database" - e.g. categories that are getting added to the system, maybe they belong as constants instead

* git config merge by rebase
	checkout [branch]
					autosetupmerge = true
					autosetuprebase = always
			   
   git clean spec

* ruby system command passing in arguments as comma delimited arguments to the method

* http://blog.deveo.com/immutability-in-ruby-part-1-data-structures/

* http://betterspecs.org/

* checkout hash slice

Slice a hash to include only the given keys. This is useful for limiting an options hash to valid keys before passing to a method:

    def search(criteria = {})
    criteria.assert_valid_keys(:mass, :velocity, :time)
    end

    search(options.slice(:mass, :velocity, :time))
    If you have an array of keys you want to limit to, you should splat them:

    valid_keys = [:mass, :velocity, :time]
    search(options.slice(*valid_keys))

* git stash; git stash pop

* bundle update rspec rspec-rails to update both

* checkout stub_chain (Note: this is deprecated Myron Marston considers this a code smell)

    describe "stubbing a chain of methods" do
    subject { Object.new }

    context "given symbols representing methods" do
        it "returns the correct value" do
        subject.stub_chain(:one, :two, :three).and_return(:four)
        subject.one.two.three.should eq(:four)
        end
    end

    context "given a string of methods separated by dots" do
        it "returns the correct value" do
        subject.stub_chain("one.two.three").and_return(:four)
        subject.one.two.three.should eq(:four)
        end
    end
    end

* factory girl build_stubbed:
it returns an object with all of the attributes for the model stubbed out

* checkout Ruby's SimpleDelegator

* git log -p filename

* ruby debugger set breakpoint in debug session with b (getting location of method definition by asking debugger)

* attributes does not grab associated model attributes

* when passing in mass assignment parameters do a reject_if to remove blank params

* Ruby 2 new features: http://globaldev.co.uk/2012/11/ruby-2-0-0-preview-features/

* git log -p filename (-p gives diff of files)

* comparing arrays in rspec use match_array

* RubyMine ctrl-w

* rake:stats


http://golangtutorials.blogspot.com/2011/06/anonymous-fields-in-structs-like-object.html

* "problem exists between chair and keyboard"

* in Rails console you can use underscore to refer to the last assigned local variable

* instance_eval(&block) to execute the block in the lexical scope of the method that you are calling instance eval in

* dup or clone of a hash is a shallow copy, nested arrays or hashes are references to the original

* check out mocking and stubbing with(hash_including
