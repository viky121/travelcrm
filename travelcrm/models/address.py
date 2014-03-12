# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    )
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.hybrid import hybrid_property

from ..models import (
    DBSession,
    Base
)


class Address(Base):
    __tablename__ = 'address'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_address",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref('address', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )

    @hybrid_property
    def name(self):
        return self.last_name + " " + self.first_name

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)