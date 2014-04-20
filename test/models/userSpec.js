require('coffee-script').register();

var should = require('should')
  , supertest = require('supertest')
  , _ = require('underscore')

var User = require('../../models/user');
var user_data = require('../data/user');

describe('User', function () {

  describe('.attributes_structure.fields', function(){
    it('returns id, email, password and repeat_password',
      function() {
        User.attributes_structure.fields.should.eql(['id', 'email', 'password', 'password_confirmation']);
      }
    );
  });

  describe('validation', function(){
    var user = {};
    beforeEach(function(){
      user = user_data.correct_user;
    });

    describe('id', function(){
      it('set error "It must be string" if id = null', function(){

        user.id = null;

        var userModel = new User(user);

        userModel.errors['id'].should.containEql('It must be string');
      });

      it('set true if id is a string', function(){

        user.id = 'string';

        var userModel = new User(user);

        userModel.errors.should.not.have.keys('id');
      });
    });

    describe('password', function(){
      it('set error "It must be string" if password = null', function(){

        user.password = null;

        var userModel = new User(user);

        userModel.errors['password'].should.containEql('password must be a string');
      });

      it('set true if id is a string', function(){

        user.password = 'password';

        var userModel = new User(user);

        userModel.errors.should.not.have.keys('password');
      });
    });
  });
});